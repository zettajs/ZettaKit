//
//  ZIKRoot.h
//  ReactiveLearning
//
//  Created by Matthew Dobson on 4/7/15.
//  Copyright (c) 2015 Matthew Dobson. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 The `ZIKRoot` class is responsible for representing the entry point into a Zetta HTTP API.
 */

@interface ZIKRoot : NSObject

/**
 An `NSArray` of `ZIKLink` objects. Represents current links available for navigating in the current context.
 */
@property (nonatomic, retain) NSArray *links;

/**
 An `NSArray` of `NSDictionary` objects. Represents the actions that can be taken in the current context.
 */
@property (nonatomic, retain) NSArray *actions;

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
- (id) initWithDictionary:(NSDictionary *)data;


@end
