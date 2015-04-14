//
//  ZIKServer.h
//  ReactiveLearning
//
//  Created by Matthew Dobson on 4/7/15.
//  Copyright (c) 2015 Matthew Dobson. All rights reserved.
//

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
- (id) initWithDictionary:(NSDictionary *)data;

@end
