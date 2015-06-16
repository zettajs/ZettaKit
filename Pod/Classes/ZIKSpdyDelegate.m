//
//  ZIKSpdyDelegate.m
//  Pods
//
//  Created by Matthew Dobson on 6/12/15.
//
//


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
