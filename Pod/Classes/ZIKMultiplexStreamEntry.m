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
    }
    return self;
}

@end
