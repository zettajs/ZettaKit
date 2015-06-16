//
//  ZIKServer.h
//  ZettaKit
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

#import <Foundation/Foundation.h>

/**
 The `ZIKServer` class abstracts away the Zetta server resource.
 */

@interface ZIKServer : NSObject

/**
 The devices that currently belong to the server. An `NSArray` of `ZIKDevice` objects.
 */
@property (nonatomic, retain) NSArray *devices;

/**
 The human readable name of the server.
 */
@property (nonatomic, retain) NSString *name;

/**
 The links that are relevant to the current server context. An `NSArray` of `ZIKLink` objects.
 */
@property (nonatomic, retain, readonly) NSArray *links;

///---------------------------
/// @name Initialization
///---------------------------

/**
 Initializes a `ZIKServer` with the specified siren document in `NSDictionary` form.
 
 This is the designated initializer.
 
 @param data The base siren document to create the server with.
 
 @return The newly-initialized `ZIKServer` object.
 */
+ (instancetype) initWithDictionary:(NSDictionary *)data;

/**
 Initializes a `ZIKServer` with the specified siren document in `NSDictionary` form.
 
 @param data The base siren document to create the server with.
 
 @return The newly-initialized `ZIKServer` object.
 */
- (instancetype) initWithDictionary:(NSDictionary *)data;

@end
