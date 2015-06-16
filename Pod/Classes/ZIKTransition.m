//
//  ZIKTransition.m
//  ReactiveLearning
//
//  Created by Matthew Dobson on 4/13/15.
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
