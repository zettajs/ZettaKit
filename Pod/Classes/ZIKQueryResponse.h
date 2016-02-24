//
//  ZIKQueryResponse.h
//  Pods
//
//  Created by Matthew Dobson on 2/17/16.
//
//

#import "ZIKStream.h"

#import <Foundation/Foundation.h>

@interface ZIKQueryResponse : NSObject

/**
 Links included with the query response.
 */
@property (nonatomic, retain, readonly) NSArray *links;

/**
 The devices that fulfill the query.
 */
@property (nonatomic, retain) NSArray *devices;

/**
 The server the query was executed against.
 */
@property (nonatomic, retain, readonly) NSString *server;

/**
 The CAQL query language used to filter devices.
 */
@property (nonatomic, retain,readonly) NSString *ql;

///---------------------------
/// @name Initialization
///---------------------------

/**
 Initializes a `ZIKQueryResponse` with the specified websocket document in `NSDictionary` form.
 
 @param data The base siren document to create the stream entry with.
 
 @return The newly-initialized `ZIKQueryResponse` object.
 */

-(instancetype) initWithDictionary:(NSDictionary *) data;

/**
 Initializes a `ZIKQueryResponse` with the specified websocket document in `NSDictionary` form.
 
 This is the designated initializer.
 
 @param data The base siren document to create the stream entry with.
 
 @return The newly-initialized `ZIKQueryResponse` object.
 */

+(instancetype) initWithDictionary:(NSDictionary *) data;

/**
 Creates a `ZIKStream` of results.
 
 @return `ZIKStream` that will update with devices that fulfill the query.
 */
-(ZIKStream *) resultsStream;

@end