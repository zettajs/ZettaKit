//
//  ZIKRoot.m
//  ReactiveLearning
//
//  Created by Matthew Dobson on 4/7/15.
//  Copyright (c) 2015 Matthew Dobson. All rights reserved.
//

#import "ZIKRoot.h"
#import "ZIKLink.h"

@interface ZIKRoot ()

@property (nonatomic, retain) ZIKLink *href;

@end

@implementation ZIKRoot

+ (instancetype) initWithDictionary:(NSDictionary *)data {
    return [[ZIKRoot alloc] initWithDictionary:data];
}

- (id) initWithDictionary:(NSDictionary *)data {
    if (self = [super init]) {
        if ([data objectForKey:@"links"]) {
            NSMutableArray *links = [[NSMutableArray alloc] init];
            for (NSDictionary *linkData in data[@"links"]) {
                ZIKLink *link = [ZIKLink initWithDictionary:linkData];
                if ([link isSelf]) {
                    self.href = link;
                }
                [links addObject:link];
            }
            
            self.links = [NSArray arrayWithArray:links];
        }
        
        if ([data objectForKey:@"actions"]) {
            self.actions = data[@"actions"];
        }
        
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<ZIKRoot: %@>", self.href];
}

@end
