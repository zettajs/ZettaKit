//
//  ZIKStream.h
//  ReactiveLearning
//
//  Created by Matthew Dobson on 4/7/15.
//  Copyright (c) 2015 Matthew Dobson. All rights reserved.
//

#import "ZIKLink.h"
#import <SocketRocket/SRWebSocket.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

/**
 The `ZIKStream` class is responsible for connecting to different Zetta websocket streams and giving real time access to data from the Zetta HTTP API.
 */

@interface ZIKStream : NSObject<SRWebSocketDelegate>

/**
 The human readable name of the stream.
 */
@property (nonatomic, retain) NSString *title;

/**
 The ReactiveCocoa signal needed to subscribe to updates from the stream.
 */
@property (nonatomic, retain) RACSignal *signal;

///---------------------------
/// @name Initialization
///---------------------------

/**
 Initializes a `ZIKStream` with the specified siren document in `NSDictionary` form.
 
 @param data The base siren document to create the stream with.
 
 @return The newly-initialized `ZIKStream` object.
 */
+ (instancetype) initWithDictionary:(NSDictionary *)data;

/**
 Initializes a `ZIKStream` with the specified siren document in `NSDictionary` form.
 
 @param data The base siren document to create the stream with.
 
 @return The newly-initialized `ZIKStream` object.
 */
- (id) initWithDictionary:(NSDictionary *)data;

/**
 Initializes a `ZIKStream` with the specified siren document in `ZIKLink` form.
 
 This is the designated initializer.
 
 @param link The `ZIKLink` object to create the stream with.
 
 @return The newly-initialized `ZIKStream` object.
 */
+ (instancetype) initWithLink:(ZIKLink *)link;

/**
 Initializes a `ZIKStream` with the specified siren document in `ZIKLink` form.
 
  @param link The `ZIKLink` object to create the stream with.
 
 @return The newly-initialized `ZIKStream` object.
 */
- (id) initWithLink:(ZIKLink *)link;

///---------------------------
/// @name Stream control
///---------------------------

/**
 Begin the flow of data from the stream.
 */
- (void) resume;

/**
 End the flow of data from the stream.
 */
- (void) stop;

@end
