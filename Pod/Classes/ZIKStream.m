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
#import <ISpdy/ispdy.h>

@interface ZIKStream () <SRWebSocketDelegate>

@property (nonatomic, retain) NSString *url;

@property (nonatomic, retain) id<RACSubscriber> subscriber;
@property (nonatomic) BOOL flowing;
@property (nonatomic, retain, readwrite) NSString *title;
@property (nonatomic, retain, readwrite) RACSignal *signal;

@end

@implementation ZIKStream {
    SRWebSocket *_socket;
}

+ (instancetype) initWithDictionary:(NSDictionary *)data {
    return [[ZIKStream alloc] initWithDictionary:data];
}



- (instancetype) initWithDictionary:(NSDictionary *)data {
    if (self = [super init]) {
        if ([data objectForKey:@"title"]) {
            self.title = data[@"title"];
        }
        
        if ([data objectForKey:@"href"]) {
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
    }
    return self;
}

+ (instancetype) initWithLink:(ZIKLink *)link {
    return [[ZIKStream alloc] initWithLink:link];
}

- (id) initWithLink:(ZIKLink *)link {
    if (self = [super init]) {
        self.title = link.title;
        self.url = link.href;
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
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    if (self.subscriber != nil) {
        NSString *messageData = (NSString *)message;
        NSDictionary *data = [NSJSONSerialization JSONObjectWithData:[messageData dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
        if ([self.title isEqualToString:@"logs"]) {
            [self.subscriber sendNext:[ZIKLogStreamEntry initWithDictionary:data]];
        } else {
            [self.subscriber sendNext:[ZIKStreamEntry initWithDictionary:data]];
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
    }
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<ZIKStream: %@>", self.title];
}

@end
