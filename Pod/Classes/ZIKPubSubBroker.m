//
//  ZIKPubSubBroker.m
//  Pods
//
//  Created by Matthew Dobson on 6/16/15.
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


#import "ZIKPubSubBroker.h"
#import "ZIKSpdyDelegate.h"
#import "ZIKSession.h"

@interface ZIKPubSubBroker ()

@property (nonatomic, retain) NSMutableDictionary *subscriptions;
@property (nonatomic, retain) ZIKSpdyDelegate *requestDelegate;

@end

@implementation ZIKPubSubBroker

+(instancetype) sharedBroker {
    static dispatch_once_t p = 0;
    
    __strong static ZIKPubSubBroker *_sharedObject = nil;
    
    dispatch_once(&p, ^{
        _sharedObject = [[self alloc] init];
        _sharedObject.subscriptions = [[NSMutableDictionary alloc] init];
        _sharedObject.requestDelegate = nil;
    });
    
    return _sharedObject;
}

//TODO: Implement
- (void) handleConnect:(ISpdy *)conn {
    
}

//TODO: Implement
- (void) connection:(ISpdy *)conn handleError:(ISpdyError *)err {
    
}

- (void) connection:(ISpdy *)conn handlePush:(ISpdyPush *)push {
    
    __block ZIKPubSubBroker *broker = self;
    if (!self.requestDelegate) {
        self.requestDelegate = [ZIKSpdyDelegate initWithCompletion:^(ISpdyError *err, NSDictionary *headers, NSData *data) {
            NSString *requestPath = push.associated.url;
            NSArray *handlers = broker.subscriptions[requestPath];
            for (NSDictionary *handler in handlers) {
                ZIKSpdyPushHandler handlerBlock = (ZIKSpdyPushHandler)handler[@"handler"];
                handlerBlock(data);
            }
        }];
    }
    push.delegate = self.requestDelegate;
}

-(NSUUID *)subscribe:(NSString *)path withHandler:(ZIKSpdyPushHandler) handler {
    NSUUID *uuid = [NSUUID UUID];
    if ([self.subscriptions objectForKey:path] == nil) {
        self.subscriptions[path] = [[NSMutableArray alloc] init];
        NSMutableArray *subscriptionsForPath = (NSMutableArray *)self.subscriptions[path];
        NSMutableDictionary *handlerObject = [[NSMutableDictionary alloc] initWithObjectsAndKeys:uuid, @"uuid", nil];
        [handlerObject setObject:[handler copy] forKey:@"handler"];
        [subscriptionsForPath addObject:handlerObject];
    } else {
        NSMutableArray *subscriptionsForPath = (NSMutableArray *)self.subscriptions[path];
        NSMutableDictionary *handlerObject = [[NSMutableDictionary alloc] initWithObjectsAndKeys:uuid, @"uuid", nil];
        [handlerObject setObject:[handler copy] forKey:@"handler"];
        [subscriptionsForPath addObject:handlerObject];
    }
    [self sendSubscriptionRequest:path];
    return uuid;
}

-(void)unsubscribe:(NSString *)path withDescriptor:(NSUUID *)descriptor {
    if ([self.subscriptions objectForKey:path] != nil) {
        NSMutableArray *handlersForPath = self.subscriptions[path];
        NSDictionary *handlerToDelete = nil;
        for (NSDictionary *handler in handlersForPath) {
            if ([handler[@"uuid"] isEqual:descriptor]) {
                handlerToDelete = handler;
                break;
            }
        }
        [handlersForPath removeObject:handlerToDelete];
    }
}

- (void) sendSubscriptionRequest:(NSString *)url {
    ZIKSession *session = [ZIKSession sharedSession];
    ISpdyRequest *request = [[ISpdyRequest alloc] init:@"GET" url:url];
    [session spdyPushTaskWithRequest:request];
}

- (void) logSpdyEvents:(ISpdy *)conn level:(ISpdyLogLevel)level message:(NSString *)message {
    //TODO: Implement in graceful way.
}

@end
