//
//  ZIKSpdyDelegate.h
//  ZettaKit
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

#import <Foundation/Foundation.h>
#import "ispdy.h"

/**
 The `ZIKSpdyDelegate` implements a way of performing HTTP transactions over the SPDY protocol.
 */
@interface ZIKSpdyDelegate : NSObject<ISpdyRequestDelegate>

typedef void (^SPDYRequestCompletion)(ISpdyError *err, NSDictionary *headers, NSData *data);

///---------------------------
/// @name Initialization
///---------------------------

/**
 Initializes a `ZIKSpdyDelegate` with the specified request completion block.
 
 @param handler A block object that will be called when the SPDY HTTP transaction completes. This block has no return value and has three arguments: A potential SPDY error from the HTTP transaction. The return headers of the HTTP transaction. Finally the response body data of the HTTP transaction.
 
 @return The newly-initialized `ZIKSpdyDelegate` object.
 */
+ (instancetype) initWithCompletion:(SPDYRequestCompletion) block;

/**
 Initializes a `ZIKSpdyDelegate` with the specified request completion block.
 
 @param handler A block object that will be called when the SPDY HTTP transaction completes. This block has no return value and has three arguments: A potential SPDY error from the HTTP transaction. The return headers of the HTTP transaction. Finally the response body data of the HTTP transaction.
 
 @return The newly-initialized `ZIKSpdyDelegate` object.
 */
- (instancetype) initWithCompletion:(SPDYRequestCompletion) block;

@end
