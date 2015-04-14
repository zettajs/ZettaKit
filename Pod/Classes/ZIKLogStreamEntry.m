//
//  ZIKLogStreamEntry.m
//  ReactiveLearning
//
//  Created by Matthew Dobson on 4/13/15.
//  Copyright (c) 2015 Matthew Dobson. All rights reserved.
//

#import "ZIKLogStreamEntry.h"

@interface ZIKLogStreamEntry ()

@property (nonatomic, retain, readwrite) NSString *topic;
@property (nonatomic, retain, readwrite) NSNumber *timestamp;
@property (nonatomic, retain, readwrite) NSString *transition;
@property (nonatomic, retain, readwrite) NSString *deviceState;

@end

@implementation ZIKLogStreamEntry

- (id) initWithDictionary:(NSDictionary *)data {
    if (self = [super init]) {
        self.timestamp = data[@"timestamp"];
        self.topic = data[@"topic"];
        NSDictionary *properties = data[@"properties"];
        self.deviceState = properties[@"state"];
        self.transition = data[@"transition"];
    }
    return self;
}

+ (instancetype) initWithDictionary:(NSDictionary *)data {
    return [[ZIKLogStreamEntry alloc] initWithDictionary:data];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<ZIKStreamEntry: %@ = %@>", self.topic, self.deviceState];
}
@end
