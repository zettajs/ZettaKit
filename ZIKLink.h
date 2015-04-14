//
//  ZIKLink.h
//  ReactiveLearning
//
//  Created by Matthew Dobson on 4/13/15.
//  Copyright (c) 2015 Matthew Dobson. All rights reserved.
//

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
- (id) initWithDictionary:(NSDictionary *)data;

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
