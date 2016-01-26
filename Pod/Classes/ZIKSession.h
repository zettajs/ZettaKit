//
//  ZIKSession.h
//  ZettaKit
//
//  Created by Matthew Dobson on 4/3/15.
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
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "ZIKQuery.h"
#import "ispdy.h"

/**
 The `ZIKSession` class manages most API transactions that take place with the Zetta HTTP API. It uses reactive programming to provide a robust model of API traversal and filtering.
 */
@interface ZIKSession : NSObject

typedef void (^ServerCompletionBlock)(NSError *error, ZIKServer *server);
typedef void (^DevicesCompletionBlock)(NSError *error, NSArray *devices);

/**
 The current endpoint the `ZIKSession` is targeting. All requests will be made against this endpoint unless specifically provided another URL.
 */
@property (nonatomic, retain, readonly) NSURL* apiEndpoint;

///---------------------------
/// @name Initialization
///---------------------------

/**
 Initialize the singleton for this session.
 
 @return The newly initialized `ZIKSession`.
 */
+(instancetype) sharedSession;

///---------------------------
/// @name Crawling the Zetta API
///---------------------------

/**
 Load the root representation of a Zetta HTTP API. 
 
 @param url The url of the particular endpoint to load.
 
 @return An RACSignal object that can be subscribed to and operated on using ReactiveCocoa extensions.
 */
- (RACSignal *) root:(NSURL *)url;

/**
 Load any representation of a Zetta HTTP API.
 
 @param url The url of the particular resource to load.
 
 @return An RACSignal object that can be subscribed to and operated on using ReactiveCocoa extensions.
 */
- (RACSignal *) load:(NSURL *)url;

/**
 Load servers from a root representation of a Zetta HTTP API.
 
 @param rootObservable The RACSignal result of retrieving the root of a Zetta HTTP API.
 
 @return An RACSignal object that can be subsribed to and operated on. This RACSignal will produce `ZIKServer` objects.
 */
- (RACSignal *) servers:(RACSignal *)rootObservable;

/**
 Load devices from a server representation of a Zetta HTTP API.
 
 @param serverObservable The RACSignal result of retrieving a server from a Zetta HTTP API.
 
 @return An RACSignal object that can be subsribed to and operated on. This RACSignal will produce `ZIKDevice` objects.
 */
- (RACSignal *) devices:(RACSignal *)serverObservable;

///---------------------------
/// @name Querying for servers and devices
///---------------------------

/**
 Query devices from a Zetta HTTP API.
 
 @param queries An `NSArray` of `ZIKQuery` objects containing information on the devices that should be retrieved.
 
 @return An RACSignal object that can be subscribed to and operated on. This RACSignal will produce `ZIKDevice` objects.
 */
- (RACSignal *) queryDevices:(NSArray *)queries;

/**
 Search for a Zetta server by name.
 
 @param name An `NSString` name of a particular Zetta server attached to the API.
 
 @return An RACSignal object that can be subscribed to and operated on. This RACSignal will produce `ZIKServer` objects.
 */
- (RACSignal *) getServerByName:(NSString *)name;

/**
 Search for a Zetta server by name.
 
 @param name An `NSString` name of a particular Zetta server attached to the API.
 @param block A block object that will be called when the HTTP transaction completes. This block has no return value and has two arguments: The potential error from the HTTP transaction, and the `ZIKServer` object representing the server.
 */
- (void) getServerByName:(NSString *)name withCompletion:(ServerCompletionBlock)block;

/**
 Query devices from a Zetta HTTP API.
 
 @param queries An `NSArray` of `ZIKQuery` objects containing information on the devices that should be retrieved.
 @param block A block object that will be called when the HTTP transaction completes. This block has no return value and has two arguments: The potential error from the HTTP transaction, and an `NSArray` of `ZIKDevice` objects that fullfil the query.
 */
- (void) queryDevices:(NSArray *)queries withCompletion:(DevicesCompletionBlock)block;

/**
 Start an HTTP task over the Zetta API, and receive an observable for it.
 
 @param req An NSURLRequest for the task that needs to be executed.
 
 @return An RACSignal object that can be subscribed to an operated on. Subscription to this observable will send back a siren document.
 */
- (RACSignal *) taskForRequest:(NSURLRequest *)req;

///---------------------------
/// @name SPDY Specific tasks
///---------------------------

/**
 Start a persistent SPDY connection at the particular endpoint.
 
 @param spdyEndpoint An NSURL that points at a SPDY enabled Zetta server.
 */
- (void) useSpdyWithURL:(NSURL*)spdyEndpoint;

/**
 End a persistent SPDY connection at the particular endpoint.
 */
- (void) endSpdySession;

/**
 Check if the current instance of `ZIKSession` is using a SPDY connection.
 */
- (BOOL) usingSpdy;

/**
 Start a SPDY push stream for the particular `ISpdyRequest`.
 
 @param request An `ISpdyRequest` object will start a set of SPDY push streams.
 */
- (void) spdyPushTaskWithRequest:(ISpdyRequest *)request;

///---------------------------
/// @name Request configuration tasks
///---------------------------

/**
 Set headers that will be included with every outgoing request.
 
 @param headers An NSDictionary of key value pairs representing HTTP Headers.
 */
- (void) setHeaders:(NSDictionary *)headers;

/**
 Set a header that will be sent with every outgoing request.
 
 @param key An NSString with the name of the header to be set.
 @param value The value of the header to be sent.
 */
- (void) setHeader:(NSString *)key forValue:(id)value;

/**
 Un-set the header value that goes out with each HTTP request.
 
 @param key An NSString with the name of the header to be un-set.
 */
- (void) unsetHeader:(NSString *)key;
@end
