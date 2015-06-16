//
//  ZIKPubSubBroker.h
//  Pods
//
//  Created by Matthew Dobson on 6/16/15.
//
//

#import <Foundation/Foundation.h>
#import <ISpdy/ispdy.h>

@interface ZIKPubSubBroker : NSObject<ISpdyDelegate>

typedef void (^ZIKSpdyPushHandler)(NSData *pushData);

+(instancetype) sharedBroker;

-(NSUUID *)subscribe:(NSString *)path withHandler:(ZIKSpdyPushHandler) handler;
-(void)unsubscribe:(NSString *)path withDescriptor:(NSUUID *)descriptor;

@end
