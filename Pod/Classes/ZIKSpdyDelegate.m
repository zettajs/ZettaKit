//
//  ZIKSpdyDelegate.m
//  Pods
//
//  Created by Matthew Dobson on 6/12/15.
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



//Experimental object for SPDY support
//It implements the request delegate protocol.
#import "ZIKSpdyDelegate.h"

@interface ZIKSpdyDelegate ()

@property (nonatomic, copy) SPDYRequestCompletion block;
@property (nonatomic, retain) NSDictionary *headers;
@property (nonatomic, retain) NSData *data;

@end

@implementation ZIKSpdyDelegate

+ (instancetype) initWithCompletion:(SPDYRequestCompletion) block {
    return [[ZIKSpdyDelegate alloc] initWithCompletion:block];
}

- (id) initWithCompletion:(SPDYRequestCompletion) block {
    if (self = [super init]) {
        self.block = block;
        self.headers = nil;
        self.data = nil;
    }
    return self;
}

- (void) request:(ISpdyRequest *)req handleHeaders:(NSDictionary *)headers {
    self.headers = headers;
}

- (void) request:(ISpdyRequest *)req handleEnd:(ISpdyError *)err {
    self.block(err, self.headers, self.data);
}

- (void) request:(ISpdyRequest *)req handleInput:(NSData *)input {
    self.data = input;
}

- (void) request:(ISpdyRequest *)req handleResponse:(ISpdyResponse *)res {
    
}

@end
