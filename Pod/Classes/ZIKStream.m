//
//  ZIKStream.m
//  ReactiveLearning
//
//  Created by Matthew Dobson on 4/7/15.
//  Copyright (c) 2015 Apigee and Contributors <matt@apigee.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.


#import "ZIKStream.h"
#import "ZIKSession.h"
#import <SocketRocket/SRWebSocket.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "ZIKStreamEntry.h"
#import "ZIKLogStreamEntry.h"
#import "ZIKSpdyDelegate.h"
#import "ZIKPubSubBroker.h"
#import "ZIKMultiplexStreamEntry.h"
#import "ZIKDevice.h"
#import "ispdy.h"

@interface ZIKStream () <SRWebSocketDelegate>

@property (nonatomic, retain) NSString *url;

@property (nonatomic, retain) id<RACSubscriber> subscriber;
@property (nonatomic) BOOL flowing;
@property (nonatomic, retain, readwrite) NSString *title;
@property (nonatomic, retain, readwrite) NSArray *rel;
@property (nonatomic, retain, readwrite) RACSignal *signal;
@property (nonatomic, readwrite) BOOL multiplexed;
@property (nonatomic, readwrite) NSTimer *timer;

@end

@implementation ZIKStream {
    SRWebSocket *_socket;
    NSMutableDictionary *_subscriptions;
    NSMutableArray *_pending;
}

+ (instancetype) initWithDictionary:(NSDictionary *)data {
    return [[ZIKStream alloc] initWithDictionary:data andIsMultiplex:NO];
}

+ (instancetype) initMultiplexedSocketWithDictionary:(NSDictionary *)data {
    return [[ZIKStream alloc] initWithDictionary:data andIsMultiplex:YES];
}


- (instancetype) initWithDictionary:(NSDictionary *)data andIsMultiplex:(BOOL)multiplexed {
    if (self = [super init]) {
        self.multiplexed = multiplexed;
        self.pingWhileOpen = YES;
        if(self.multiplexed == YES) {
            _subscriptions = [[NSMutableDictionary alloc] init];
        }
        if ([data objectForKey:@"title"]) {
            self.title = data[@"title"];
        }
        
        if ([data objectForKey:@"href"]) {
            //self.href = data[@"href"];
            self.url = data[@"href"];
            self.flowing = NO;
            NSURL *streamUrl = [NSURL URLWithString:self.url];
            ZIKSession *session = [ZIKSession sharedSession];
            if ([session usingSpdy]) {
                NSString * streamPath = [NSString stringWithFormat:@"%@?%@", streamUrl.path, streamUrl.query];
                ZIKPubSubBroker *broker = [ZIKPubSubBroker sharedBroker];
                [broker subscribe:streamPath withHandler:^(NSData *pushData) {
                }];
            } else {
                _socket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:streamUrl]];
                _socket.delegate = self;
                @weakify(self)
                self.signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                    @strongify(self)
                    self.subscriber = subscriber;
                    return nil;
                }];
            }
        }
        
        if ([data objectForKey:@"rel"]) {
            self.rel = data[@"rel"];
        }
    }
    return self;
}

+ (instancetype) initWithLink:(ZIKLink *)link {
    return [[ZIKStream alloc] initWithLink:link andIsMultiplex:NO];
}

- (instancetype) initWithLink:(ZIKLink *)link andIsMultiplex:(BOOL)multiplexed {
    if (self = [super init]) {
        self.multiplexed = multiplexed;
        self.pingWhileOpen = YES;
        self.title = link.title;
        self.url = link.href;
        self.rel = link.rel;
        self.flowing = NO;
        NSURL *streamUrl = [NSURL URLWithString:self.url];
        ZIKSession *session = [ZIKSession sharedSession];
        if ([session usingSpdy]) {
            NSString * streamPath = [NSString stringWithFormat:@"%@?%@", streamUrl.path, streamUrl.query];
            __block ZIKPubSubBroker *broker = [ZIKPubSubBroker sharedBroker];
            @weakify(self)
            self.signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self)
                self.subscriber = subscriber;
                [broker subscribe:streamPath withHandler:^(NSData *pushData) {
                    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:pushData options:0 error:nil];
                    if (self.flowing) {
                        if ([self.title isEqualToString:@"logs"]) {
                            [self.subscriber sendNext:[ZIKLogStreamEntry initWithDictionary:data]];
                        } else {
                            [self.subscriber sendNext:[ZIKStreamEntry initWithDictionary:data]];
                        }
                    }
                }];
                return nil;
            }];
        } else {
            _socket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:streamUrl]];
            _socket.delegate = self;
            @weakify(self)
            self.signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self)
                self.subscriber = subscriber;
                return nil;
            }];
        }

    }
    return self;
}

- (void) resume {
    ZIKSession *session = [ZIKSession sharedSession];
    if ([session usingSpdy]) {
        self.flowing = YES;
    } else {
        [_socket open];
        if (self.pingWhileOpen) {
            self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(ping) userInfo:nil repeats:YES];
        }
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    if (self.subscriber != nil) {
        NSString *messageData = (NSString *)message;
        NSDictionary *data = [NSJSONSerialization JSONObjectWithData:[messageData dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        if (self.multiplexed) {
            ZIKMultiplexStreamEntry *entry = [ZIKMultiplexStreamEntry initWithDictionary:data];
            if ([entry.type isEqualToString:@"error"]) {
                NSError *error = [[NSError alloc] initWithDomain:@"org.zettakit" code:[entry.code integerValue] userInfo:@{@"message": entry.message}];
                [self.subscriber sendNext:entry];
                [self.subscriber sendError:error];
            } else if ([entry.type isEqualToString:@"subscribe-ack"]) {
                NSString *topic = entry.topic;
                NSString *subscriptionId = entry.subscriptionId;
                [_pending removeObject:topic];
                _subscriptions[topic] = subscriptionId;
                [self.subscriber sendNext:entry];
            } else if ([entry.type isEqualToString:@"unsubscribe-ack"]) {
                NSString *topic = entry.topic;
                [_subscriptions removeObjectForKey:topic];
                [self.subscriber sendNext:entry];
            } else if ([entry.type isEqualToString:@"data"]) {
                [self.subscriber sendNext:entry];
            } else {
                NSError *error = [[NSError alloc] initWithDomain:@"org.zettakit" code:0 userInfo:@{@"message": @"Message missing type."}];
                [self.subscriber sendNext:entry];
                [self.subscriber sendError:error];
            }
        } else {
            if ([self.title isEqualToString:@"logs"]) {
                [self.subscriber sendNext:[ZIKLogStreamEntry initWithDictionary:data]];
            } else if ([self.rel containsObject:@"http://rels.zettajs.io/query"]) {
                [self.subscriber sendNext:[ZIKDevice initWithDictionary:data]];
            } else {
                [self.subscriber sendNext:[ZIKStreamEntry initWithDictionary:data]];
            }
        }
    } else {
        NSLog(@"Subscriber is nil");
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    if (self.subscriber != nil) {
        [self.subscriber sendCompleted];
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    if (self.subscriber != nil) {
        [self.subscriber sendError:error];
    }
}

- (void) stop {
    ZIKSession *session = [ZIKSession sharedSession];
    if ([session usingSpdy]) {
        self.flowing = NO;
    } else {
        [_socket close];
        if (self.pingWhileOpen) {
            //clear timer
            [self.timer invalidate];
            self.timer = nil;
        }
    }
}

- (void) subscribe:(NSString *)topic {
    NSDictionary *data = @{ @"type": @"subscribe", @"topic": topic};
    [self subscribeWithObject:data];
}

- (void) subscribe:(NSString *)topic withLimit:(NSNumber*)limit {
    NSDictionary *data = @{ @"type": @"subscribe", @"topic": topic, @"limit": limit};
    [self subscribeWithObject:data];
}

- (void) subscribe:(NSString *)topic withLimit:(NSNumber*)limit andQl:(NSString *)ql {
    NSString *fullTopic = [NSString stringWithFormat:@"%@?%@", topic, ql];
    NSDictionary *data = @{ @"type": @"subscribe", @"topic": fullTopic, @"limit": limit};
    [self subscribeWithObject:data];
}

- (void) subscribe:(NSString *)topic withQl:(NSString*)ql {
    NSString *fullTopic = [NSString stringWithFormat:@"%@?%@", topic, ql];
    NSDictionary *data = @{ @"type": @"subscribe", @"topic": fullTopic};
    [self subscribeWithObject:data];
}

- (void) unsubscribe:(NSString *)topic {
    NSString *subscriptionId = [self subscriptionIdForTopic:topic];
    NSDictionary *data = @{@"type": @"unsubscribe", @"subscriptionId": subscriptionId};
    [self subscribeWithObject:data];
}

- (void) subscribeWithObject:(NSDictionary *)data {
    if (self.multiplexed) {
        [_pending addObject:data[@"topic"]];
        [self write:data];
    }
}

- (NSString *) subscriptionIdForTopic:(NSString *) topic {
    return _subscriptions[topic];
}

- (void) write:(NSDictionary *)data {
    NSError *error = nil;
    NSData *serializedData = [NSJSONSerialization dataWithJSONObject:data options:kNilOptions error:&error];
    NSString *subscriptionString = [[NSString alloc] initWithData:serializedData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", subscriptionString);
    [_socket send:subscriptionString];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<ZIKStream: %@>", self.url];
}

- (BOOL) isOpen {
    return _socket.readyState == SR_OPEN;
}

- (void) ping {
    [_socket sendPing:[NSData data]];
}

@end
