//
//  ZIKQuery.m
//  ReactiveLearning
//
//  Created by Matthew Dobson on 4/7/15.
//  Copyright (c) 2015 Matthew Dobson. All rights reserved.
//

#import "ZIKQuery.h"

@interface ZIKQuery ()

@property (nonatomic, retain, readwrite) NSString *query;
@property (nonatomic, retain, readwrite) ZIKServer *server;

@end

@implementation ZIKQuery

+ (instancetype) queryFromString:(NSString *)query fromServer:(ZIKServer *)server {
    return [[ZIKQuery alloc] initWithQuery:query andServer:server];
}

- (id) initWithQuery:(NSString *)query andServer:(ZIKServer *)server {
    if (self = [super init]) {
        self.query = query;
        self.server = server;
    }
    return self;
}

@end
