//
//  ZIKLogStreamEntry.h
//  ReactiveLearning
//
//  Created by Matthew Dobson on 4/13/15.
//  Copyright (c) 2015 Matthew Dobson. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 The `ZIKStreamEntry` object is responsible for encapsulating parsed messages from the Zetta Log WebSocket API.
 */
@interface ZIKLogStreamEntry : NSObject

/**
 The topic of the stream. String takes format of "DEVICE_TYPE/DEVICE_UUID/STREAM_NAME"
 */
@property (nonatomic, retain, readonly) NSString *topic;

/**
 The timestamp of the data reading.
 */
@property (nonatomic, retain, readonly) NSNumber *timestamp;

/**
 The transition that occured on the `ZIKDevice`
 */
@property (nonatomic, retain, readonly) NSString *transition;

/**
 The device state at the moment of the transition.
 */
@property (nonatomic, retain, readonly) NSString *deviceState;

///---------------------------
/// @name Initialization
///---------------------------

/**
 Initializes a `ZIKLogStreamEntry` with the specified websocket document in `NSDictionary` form.
 
 This is the designated initializer.
 
 @param data The base websocket document to create the stream entry with.
 
 @return The newly-initialized `ZIKLogStreamEntry` object.
 */
+ (instancetype) initWithDictionary:(NSDictionary *)data;

/**
 Initializes a `ZIKLogStreamEntry` with the specified websocket document in `NSDictionary` form.
 
 @param data The base websocket document to create the stream entry with.
 
 @return The newly-initialized `ZIKLogStreamEntry` object.
 */
- (id) initWithDictionary:(NSDictionary *)data;

@end
