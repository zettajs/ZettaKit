//
//  ZIKTransition.h
//  ReactiveLearning
//
//  Created by Matthew Dobson on 4/13/15.
//  Copyright (c) 2015 Matthew Dobson. All rights reserved.
//

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
- (id) initWithDictionary:(NSDictionary *)data;

///---------------------------
/// @name HTTP Request Construction
///---------------------------

/**
 Creates an `NSMutableRequest` for the current `ZIKTransition`
 
 @return An `NSMutableRequest` object. Will contain 
 */
- (NSMutableURLRequest *) createRequestForTransition;

@end
