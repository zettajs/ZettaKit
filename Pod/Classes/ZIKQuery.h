//
//  ZIKQuery.h
//  ReactiveLearning
//
//  Created by Matthew Dobson on 4/7/15.
//  Copyright (c) 2015 Matthew Dobson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZIKServer.h"

/**
 A `ZIKQuery` object represents a Zetta device query over the HTTP API.
 */
@interface ZIKQuery : NSObject

/**
 The CAQL query language used to filter devices.
 */
@property (nonatomic, retain, readonly) NSString *query;

/**
 The particular server that devices will be queried for devices.
 */
@property (nonatomic, retain, readonly) ZIKServer *server;

///---------------------------
/// @name Initialization
///---------------------------

/**
 Initializes a `ZIKQuery` with the specified query and `ZIKServer` object.
 
 This is the designated initializer.
 
 @param query The base CAQL query used to filter devices.
 @param server The server to perform the query on.
 
 @return The newly-initialized `ZIKStreamEntry` object.
 */
+ (instancetype) queryFromString:(NSString *)query fromServer:(ZIKServer *)server;

/**
 Initializes a `ZIKQuery` with the specified query and `ZIKServer` object.
 
 @param query The base CAQL query used to filter devices.
 @param server The server to perform the query on.
 
 @return The newly-initialized `ZIKStreamEntry` object.
 */
- (id) initWithQuery:(NSString *)query andServer:(ZIKServer *)server;

@end
