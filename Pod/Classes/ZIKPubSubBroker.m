//
//  ZIKPubSubBroker.m
//  Pods
//
//  Created by Matthew Dobson on 6/16/15.
//
//

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

- (void) handleConnect:(ISpdy *)conn {
    
}

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

@end
