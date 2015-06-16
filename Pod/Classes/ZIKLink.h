//
//  ZIKLink.h
//  ZettaKit
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

#import <Foundation/Foundation.h>

/**
 The `ZIKLink` object represents a link in the Zetta HTTP API.
 */
@interface ZIKLink : NSObject

/**
 The url of the link.
 */
@property (nonatomic, retain, readonly) NSString *href;

/**
 An `NSArray` of `NSString` objects that include relevant data on the links relationship to the current context.
 */
@property (nonatomic, retain, readonly) NSArray *rel;

/**
 The human readable name of the link.
 */
@property (nonatomic, retain, readonly) NSString *title;

///---------------------------
/// @name Initialization
///---------------------------

/**
 Initializes a `ZIKLink` with the specified siren document in `NSDictionary` form.
 
 This is the designated initializer.
 
 @param data The base siren document to create the link with.
 
 @return The newly-initialized `ZIKLink` object.
 */
+ (instancetype) initWithDictionary:(NSDictionary *)data;

/**
 Initializes a `ZIKLink` with the specified siren document in `NSDictionary` form.
 
 @param data The base siren document to create the link with.
 
 @return The newly-initialized `ZIKLink` object.
 */
- (instancetype) initWithDictionary:(NSDictionary *)data;

/**
 Checks whether a rel is present in the link context.
 
 @param rel The link relation string to search for.
 
 @return Boolean indicating whether or not the relation is present.
 */
- (BOOL) hasRel:(NSString *)rel;

/**
 Checks whether the "self" relation is in the link context.
 
 @return Boolean indicating whether or not the "self" relation is present.
 */
- (BOOL) isSelf;
@end
