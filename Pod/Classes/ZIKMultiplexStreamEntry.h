//
//  ZIKMultiplexStreamEntry.h
//  Pods
//
//  Created by Matthew Dobson on 1/27/16.
//
//

#import "ZIKStreamEntry.h"

@interface ZIKMultiplexStreamEntry : ZIKStreamEntry

/**
 The subscription id for the specified websocket document.
 */
@property (nonatomic, retain, readonly) NSString *subscriptionId;

/**
 The type for the specified websocket document.
 */
@property (nonatomic, retain, readonly) NSString *type;

/**
 The error code of the specified websocket document. Only present if type is error.
 */
@property (nonatomic, retain, readonly) NSNumber *code;

/**
 The error message of the specified websocket document. Only present if type is error.
 */
@property (nonatomic, retain, readonly) NSString *message;


///---------------------------
/// @name Initialization
///---------------------------

/**
 Initializes a `ZIKMultiplexStreamEntry` with the specified websocket document in `NSDictionary` form.
 
 This is the designated initializer.
 
 @param data The base websocket document to create the stream entry with.
 
 @return The newly-initialized `ZIKStreamEntry` object.
 */
+ (instancetype) initWithDictionary:(NSDictionary *)data;

/**
 Initializes a `ZIKMultiplexStreamEntry` with the specified websocket document in `NSDictionary` form.
 
 @param data The base websocket document to create the stream entry with.
 
 @return The newly-initialized `ZIKStreamEntry` object.
 */
- (instancetype) initWithDictionary:(NSDictionary *)data;

@end
