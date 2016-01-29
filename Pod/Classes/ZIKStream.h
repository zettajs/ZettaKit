//
//  ZIKStream.h
//  ZettaKit
//
//  Created by Matthew Dobson on 4/7/15.
//  Copyright (c) 2015 Apigee and Contributors <matt@apigee.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

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
@property (nonatomic, retain, readonly) NSString *title;

/**
 The ReactiveCocoa signal needed to subscribe to updates from the stream.
 */
@property (nonatomic, retain, readonly) RACSignal *signal;

/**
 Boolean flag indicating if the socket is a multiplexed websocket stream.
 */
@property (nonatomic, readonly) BOOL multiplexed;

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
 Initializes a multiplexed capable `ZIKStream` with the specified siren document in `NSDictionary` form.
 
 @param data The base siren document to create the stream with.
 
 @return The newly-initialized `ZIKStream` object.
 */
+ (instancetype) initMultiplexedSocketWithDictionary:(NSDictionary *)data;

/**
 Initializes a `ZIKStream` with the specified siren document in `NSDictionary` form.
 
 @param data The base siren document to create the stream with.
 @param multiplexed A flag indicating whether or not a stream is a multiplexed websocket stream.
 
 @return The newly-initialized `ZIKStream` object.
 */
- (instancetype) initWithDictionary:(NSDictionary *)data andIsMultiplex:(BOOL)multiplexed;

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
- (instancetype) initWithLink:(ZIKLink *)link andIsMultiplex:(BOOL)multiplexed;

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

/**
 Method to indicate whether or not the websocket is currently open.
 
 @return BOOL indicating if underlying websocket is open.
 */
- (BOOL) isOpen;

/**
 Create a subscription for using a topic.
 
 @param An NSString containing a topic pattern for subscription.
 */
- (void) subscribe:(NSString *)topic;

/**
 Create a subscription for using a topic.
 
 @param An NSString containing a topic pattern for subscription.
 @param An NSNumber containing a limit of messages to be sent for the subscription.
 */
- (void) subscribe:(NSString *)topic withLimit:(NSNumber*)limit;

/**
 Create a subscription for using a topic.
 
 @param An NSString containing a topic pattern for subscription.
 @param An NSNumber containing a limit of messages to be sent for the subscription.
 @param An NSString with query language to filter messages on.
 */
- (void) subscribe:(NSString *)topic withLimit:(NSNumber*)limit andQl:(NSString *)ql;

/**
 Create a subscription for using a topic.
 
 @param An NSString containing a topic pattern for subscription.
 @param An NSString with query language to filter messages on.
 */
- (void) subscribe:(NSString *)topic withQl:(NSString*)ql;

/**
 Unsubscribe from a given topic.
 
 @param An NSString containing a topic pattern for subscription.
 */
- (void) unsubscribe:(NSString *)topic;


@end
