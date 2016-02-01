//
//  ZIKMultiplexStreamEntry.m
//  Pods
//
//  Created by Matthew Dobson on 1/27/16.
//
//

#import "ZIKMultiplexStreamEntry.h"

@interface ZIKMultiplexStreamEntry ()

@property (nonatomic, retain, readwrite) NSString *subscriptionId;
@property (nonatomic, retain, readwrite) NSString *type;
@property (nonatomic, retain, readwrite) NSNumber *code;
@property (nonatomic, retain, readwrite) NSString *message;

@end

@implementation ZIKMultiplexStreamEntry

+ (instancetype) initWithDictionary:(NSDictionary *)data {
    return [[ZIKMultiplexStreamEntry alloc] initWithDictionary:data];
}

- (instancetype) initWithDictionary:(NSDictionary *)data {
    if (self = [super initWithDictionary:data]) {
        if (data[@"subscriptionId"]) {
            self.subscriptionId = data[@"subscriptionId"];
        }
        
        if (data[@"type"]) {
            self.type = data[@"type"];
        }
        
        if (data[@"message"]) {
            self.message = data[@"message"];
        }
        
        if (data[@"code"]) {
            self.code = data[@"code"];
        }
    }
    return self;
}

@end
