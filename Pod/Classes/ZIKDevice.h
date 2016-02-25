//
//  ZIKDevice.h
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


#import <Foundation/Foundation.h>
#import "ZIKStream.h"

/**
 `ZIKDevice` represents a device within the Zetta API. It's used for storing device data, interacting with streaming data from the API, and calling transitions over HTTP.
 */

@interface ZIKDevice : NSObject

/**
 The current unique id of the `ZIKDevice` in the API.
 */
@property (nonatomic, retain, readonly, nonnull) NSString *uuid;

/**
 The current human readable name of the `ZIKDevice` in the API. If not nil this should be used when displaying things to a user.
 */
@property (nonatomic, retain, readonly, nullable) NSString *name;

/**
 The type of device. Classifies a device based on what it physically is.
 */
@property (nonatomic, retain, readonly, nonnull) NSString *type;

/**
 The current state of the device. If nil then the device is a sensor object with only streams.
 */
@property (nonatomic, retain, readonly, nullable) NSString *state;

/**
 The current properties of the device.
 */
@property (nonatomic, retain, readonly, nonnull) NSDictionary *properties;

/**
 The current available transitions for the device to take.
 */
@property (nonatomic, retain, readonly, nullable) NSArray *transitions;

/**
 The current links to other resources the device has. These links will represent relationships between other resources and the device.
 */
@property (nonatomic, retain, readonly, nonnull) NSArray *links;

typedef void (^CompletionBlock)(NSError * _Nullable err, ZIKDevice * _Nullable device);

///---------------------------
/// @name Initialization
///---------------------------

/**
 Initializes a `ZIKDevice` with the specified siren document in `NSDictionary` form.
 
 This is the designated initializer.
 
 @param data The base siren document to create the device with.
 
 @return The newly-initialized `ZIKDevice` object.
 */
+ (instancetype _Nonnull) initWithDictionary:(NSDictionary * _Nonnull)data;

/**
 Initializes a `ZIKDevice` with the specified siren document in `NSDictionary` form.
 
 @param data The base siren document to create the device with.
 
 @return The newly-initialized ZIKDevice object.
 */
- (instancetype _Nonnull) initWithDictionary:(NSDictionary * _Nonnull)data;

///---------------------------
/// @name Interacting with streaming data
///---------------------------

/**
 Creates a `ZIKStream` object to stream data over a websocket.
 
 @param name The name of the stream to be accessed over websocket.
 
 @return The newly initialized ZIKStream
 */
- (ZIKStream * _Nullable) stream:(NSString* _Nonnull) name;

///---------------------------
/// @name Interacting with state machine models
///---------------------------

/**
 Perform an argumentless state transition on an object. This will simply send a transition call to the API without any extra data. This particular method is a fire and forget method. No indication of completion will be given.
 
 @param name The name of the transition to execute.
 
 @return An RACSignal object that can be subscribed to and operated on. The observable subscribe to ZIKDevice instances.
 */
- (RACSignal * _Nonnull) transition:(NSString * _Nullable) name;

/**
 Perform an argumentless state transition on an object. This will simply send a transition call to the API without any extra data.
 
 @param name The name of the transition to execute.
 @param block A block object to be executed when the task finishes. This block has no return value and takes two arguments: Any error from attempting to complete the task, the new device representation from the completed task.
 
 */
- (void) transition:(NSString * _Nonnull) name andCompletion:(CompletionBlock _Nonnull)block;

/**
 Perform a transition with extra arguments. This particular method is a fire and forget method. No indication of completion will be given.
 
 @param name The name of the transition to execute.
 @param args The `NSDictionary` of key value pairs representing arguments to be given to the transition.
 
 @return An RACSignal object that can be subscribed to and operated on. The observable subscribe to ZIKDevice instances.
 */
- (RACSignal * _Nonnull) transition:(NSString * _Nonnull) name withArguments:(NSDictionary * _Nonnull)args;

/**
 Perform a transition with extra arguments.
 
 @param name The name of the transition to execute.
 @param args The `NSDictionary` of key value pairs representing arguments to be given to the transition.
 @param block A block object to be executed when the task finishes. This block has no return value and takes two arguments: Any error from attempting to complete the task, the new device representation from the completed task.
 */
- (void) transition:(NSString * _Nonnull)name withArguments:(NSDictionary * _Nonnull)args andCompletion:(CompletionBlock _Nonnull)block;

/**
 Retrieve all streams attached to a device.
 
 @return An NSArray of ZIKStream instances that correspond to every stream on the device representation.
 */
- (NSArray * _Nonnull)getAllStreams;

/**
 Fetch the current representation of the `ZIKDevice`.
 
 @return An RACSignal object that can be subscribed to and operated on using ReactiveCocoa extensions.
 */
-(RACSignal * _Nonnull)fetch;

/**
 Fetch the current representation of the `ZIKDevice`.
 
 @param block A block object that will be called when the HTTP transaction completes. This block has no return value and has two arguments: The potential error from the HTTP transaction, and the `ZIKDevice` object representing the server.
 */
-(void)fetchWithCompletion:(CompletionBlock _Nonnull)block;

@end
