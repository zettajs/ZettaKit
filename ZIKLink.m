//
//  ZIKLink.m
//  ReactiveLearning
//
//  Created by Matthew Dobson on 4/13/15.
//  Copyright (c) 2015 Matthew Dobson. All rights reserved.
//

#import "ZIKLink.h"

@interface ZIKLink ()

@property (nonatomic, retain, readwrite) NSString *href;
@property (nonatomic, retain, readwrite) NSString *title;
@property (nonatomic, retain, readwrite) NSArray *rel;

@end

@implementation ZIKLink

+ (instancetype) initWithDictionary:(NSDictionary *)data {
    return [[ZIKLink alloc] initWithDictionary:data];
}

- (id) initWithDictionary:(NSDictionary *)data {
    if (self = [super init]) {
        self.href = data[@"href"];
        self.rel = data[@"rel"];
        self.title = data[@"title"];
    }
    return self;
}

- (BOOL) hasRel:(NSString *)rel {
    return [self.rel containsObject:rel];
}

- (BOOL)isSelf {
    return [self hasRel:@"self"];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<ZIKLink: %@>", self.href];
}

@end
