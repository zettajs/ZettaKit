//
//  ZIKTransition.h
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
 The `ZIKTransition` object encapsulates performing a transition on the Zetta state machine.
 */
@interface ZIKTransition : NSObject

/**
 The human readable name of the transition.
 */
@property (nonatomic, retain, readonly) NSString *name;

/**
 The url endpoint that corresponds to the particular action.
 */
@property (nonatomic, retain, readonly) NSString *href;

/**
 The HTTP method needed to execute the transition.
 */
@property (nonatomic, retain, readonly) NSString *method;

/**
 The Content-Type required for the transition. Defaults to "application/x-www-form-urlencoded"
 */
@property (nonatomic, retain, readonly) NSString *type;

/**
 The particular input fields for a transition. `NSArray` of `NSDictionary` objects.
 */
@property (nonatomic, retain, readonly) NSArray *fields;

///---------------------------
/// @name Initialization
///---------------------------

/**
 Initializes a `ZIKTransition` with the specified siren document in `NSDictionary` form.
 
 This is the designated initializer.
 
 @param data The base siren document to create the link with.
 
 @return The newly-initialized `ZIKTransition` object.
 */
+ (instancetype) initWithDictionary:(NSDictionary *)data;

/**
 Initializes a `ZIKTransition` with the specified siren document in `NSDictionary` form.
 
 @param data The base siren document to create the link with.
 
 @return The newly-initialized `ZIKTransition` object.
 */
- (instancetype) initWithDictionary:(NSDictionary *)data;

///---------------------------
/// @name HTTP Request Construction
///---------------------------

/**
 Creates an `NSMutableRequest` for the current `ZIKTransition`
 
 @return An `NSMutableRequest` object. Will contain 
 */
- (NSMutableURLRequest *) createRequestForTransition;

@end
