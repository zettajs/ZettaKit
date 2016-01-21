//
//  ZIKPubSubBroker.h
//  ZettaKit
//
//  Created by Matthew Dobson on 6/16/15.
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
#import "ispdy.h"

/**
 The `ZIKPubSubBroker` object represents a the reciever for SPDY push streams.
 */
@interface ZIKPubSubBroker : NSObject<ISpdyDelegate, ISpdyLogDelegate>

typedef void (^ZIKSpdyPushHandler)(NSData *pushData);

///---------------------------
/// @name Initialization
///---------------------------

/**
 Initialize the singleton for this broker.
 
 @return The newly initialized `ZIKPubSubBroker`.
 */
+(instancetype) sharedBroker;

///---------------------------
/// @name Interacting with SPDY push streams.
///---------------------------

/**
 Sets up a listener for a SPDY push stream at a given API Path.
 
 @param path The string indicating the API path to subscribe to a push stream.
 @param handler A block object that will be called when the SPDY push stream sends data. This block has no return value and has one arguments: The data from the SPDY push stream.
 
 @return NSUUID A descriptor representing the current subscription. Needed for unsubscribing.
 */
-(NSUUID *)subscribe:(NSString *)path withHandler:(ZIKSpdyPushHandler) handler;

/**
 Stops a listener for a SPDY push stream at a given API Path.
 
 @param path The string indicating the API path to subscribe to a push stream.
 @param descriptor A descriptor representing the current subscription that should be stopped.
 */
-(void)unsubscribe:(NSString *)path withDescriptor:(NSUUID *)descriptor;

@end
