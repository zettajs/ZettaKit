//
//  ZIKTransition.m
//  ReactiveLearning
//
//  Created by Matthew Dobson on 4/13/15.
//  Copyright (c) 2015 Matthew Dobson. All rights reserved.
//

#import "ZIKTransition.h"

@interface ZIKTransition ()

@property (nonatomic, retain, readwrite) NSString *name;
@property (nonatomic, retain, readwrite) NSString *href;
@property (nonatomic, retain, readwrite) NSString *method;
@property (nonatomic, retain, readwrite) NSString *type;
@property (nonatomic, retain, readwrite) NSArray *fields;

@end

@implementation ZIKTransition

+ (instancetype) initWithDictionary:(NSDictionary *)data {
    return [[ZIKTransition alloc] initWithDictionary:data];
}

- (id) initWithDictionary:(NSDictionary *)data {
    if (self = [super init]) {
        self.name = data[@"name"];
        self.href = data[@"href"];
        self.method = data[@"method"];
        if ([data objectForKey:@"type"]) {
            self.type = data[@"type"];
        } else {
            self.type = @"application/x-www-form-urlencoded";
        }
        self.type = data[@"type"];
        self.fields = data[@"fields"];
    }
    return self;
}

- (NSMutableURLRequest *) createRequestForTransition {
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:self.href]];
    [req setHTTPMethod:self.method];
    [req setValue:self.type forHTTPHeaderField:@"Content-Type"];
    return req;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<ZIKTransition: %@>", self.name];
}

@end
