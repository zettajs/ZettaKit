//
//  ZIKLogStreamEntry.h
//  ZettaKit
//
//  Created by Matthew Dobson on 4/13/15.
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
- (instancetype) initWithDictionary:(NSDictionary *)data;

@end
