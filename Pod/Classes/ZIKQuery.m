//
//  ZIKQuery.m
//  ReactiveLearning
//
//  Created by Matthew Dobson on 4/7/15.
//  Copyright (c) 2015 Apigee and Contributors <matt@apigee.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.


#import "ZIKQuery.h"

@interface ZIKQuery ()

@property (nonatomic, retain, readwrite) NSString *query;
@property (nonatomic, retain, readwrite) ZIKServer *server;

@end

@implementation ZIKQuery

+ (instancetype) queryFromString:(NSString *)query fromServer:(ZIKServer *)server {
    return [[ZIKQuery alloc] initWithQuery:query andServer:server];
}

+ (instancetype) allDevicesFromServer:(ZIKServer *)server {
    return [[ZIKQuery alloc] initWithQuery:@"where type is not none" andServer:server];
}

+ (instancetype) allDevicesFromAllServers {
    NSDictionary *data = @{@"properties": @{@"name": @"*"}, @"entities": @[], @"links": @[]};
    ZIKServer *server = [ZIKServer initWithDictionary:data];
    return [[ZIKQuery alloc] initWithQuery:@"where type is not none" andServer:server];
}

+ (instancetype) queryFromStringOnAllServers:(NSString *)query {
    NSDictionary *data = @{@"properties": @{@"name": @"*"}, @"entities": @[], @"links": @[]};
    ZIKServer *server = [ZIKServer initWithDictionary:data];
    return [[ZIKQuery alloc] initWithQuery:query andServer:server];
}

- (instancetype) initWithQuery:(NSString *)query andServer:(ZIKServer *)server {
    if (self = [super init]) {
        self.query = query;
        self.server = server;
    }
    return self;
}

@end
