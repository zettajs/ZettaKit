//
//  ZIKRoot.h
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
#import "ZIKStream.h"

/**
 The `ZIKRoot` class is responsible for representing the entry point into a Zetta HTTP API.
 */

@interface ZIKRoot : NSObject

/**
 An `NSArray` of `ZIKLink` objects. Represents current links available for navigating in the current context.
 */
@property (nonatomic, retain, readonly) NSArray *links;

/**
 An `NSArray` of `NSDictionary` objects. Represents the actions that can be taken in the current context.
 */
@property (nonatomic, retain, readonly) NSArray *actions;

///---------------------------
/// @name Initialization
///---------------------------

/**
 Initializes a `ZIKRoot` with the specified siren document in `NSDictionary` form.
 
 This is the designated initializer.
 
 @param data The base siren document to create the root with.
 
 @return The newly-initialized `ZIKRoot` object.
 */
+ (instancetype) initWithDictionary:(NSDictionary *)data;

/**
 Initializes a `ZIKRoot` with the specified siren document in `NSDictionary` form.
 
 @param data The base siren document to create the root with.
 
 @return The newly-initialized `ZIKRoot` object.
 */
- (instancetype) initWithDictionary:(NSDictionary *)data;

- (ZIKStream *) multiplexWebsocketStream;


@end
