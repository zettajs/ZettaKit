//
//  ZIKStreamEntry.m
//  ReactiveLearning
//
//  Created by Matthew Dobson on 4/7/15.
//  Copyright (c) 2015 Matthew Dobson. All rights reserved.
//

#import "ZIKStreamEntry.h"

@interface ZIKStreamEntry ()

@property (nonatomic, retain, readwrite) NSString *topic;
@property (nonatomic, retain, readwrite) NSNumber *timestamp;
@property (nonatomic, retain, readwrite) id data;

@end

@implementation ZIKStreamEntry

+ (instancetype) initWithDictionary:(NSDictionary *)data {
    return [[ZIKStreamEntry alloc] initWithDictionary:data];
}

- (id) initWithDictionary:(NSDictionary *)data {
    if (self = [super init]) {
        NSNumber *timestamp = [data objectForKey:@"timestamp"];
        id dataEntry = [data objectForKey:@"data"];
        NSString *topic = [data objectForKey:@"topic"];
        if (timestamp) {
            self.timestamp = timestamp;
        }
        
        if (dataEntry) {
            self.data = dataEntry;
        }
        
        if (topic) {
            self.topic = topic;
        }
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<ZIKStreamEntry: %@ = %@>", self.topic, self.data];
}

@end
