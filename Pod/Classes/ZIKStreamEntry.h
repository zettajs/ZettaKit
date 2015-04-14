//
//  ZIKStreamEntry.h
//  ReactiveLearning
//
//  Created by Matthew Dobson on 4/7/15.
//  Copyright (c) 2015 Matthew Dobson. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 The `ZIKStreamEntry` object is responsible for encapsulating parsed messages from the Zetta WebSocket API.
 */
@interface ZIKStreamEntry : NSObject

/**
 The topic of the stream. String takes format of "DEVICE_TYPE/DEVICE_UUID/STREAM_NAME"
 */
@property (nonatomic, retain, readonly) NSString *topic;

/**
 The timestamp of the data reading.
 */
@property (nonatomic, retain, readonly) NSNumber *timestamp;

/**
 The particular data from the stream. Can be of any type.
 */
@property (nonatomic, retain, readonly) id data;

///---------------------------
/// @name Initialization
///---------------------------

/**
 Initializes a `ZIKStreamEntry` with the specified websocket document in `NSDictionary` form.
 
 This is the designated initializer.
 
 @param data The base websocket document to create the stream entry with.
 
 @return The newly-initialized `ZIKStreamEntry` object.
 */
+ (instancetype) initWithDictionary:(NSDictionary *)data;

/**
 Initializes a `ZIKStreamEntry` with the specified websocket document in `NSDictionary` form.
 
 @param data The base websocket document to create the stream entry with.
 
 @return The newly-initialized `ZIKStreamEntry` object.
 */

- (id) initWithDictionary:(NSDictionary *)data;

@end
