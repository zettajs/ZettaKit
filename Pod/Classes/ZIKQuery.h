//
//  ZIKQuery.h
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
#import "ZIKServer.h"

/**
 A `ZIKQuery` object represents a Zetta device query over the HTTP API.
 */
@interface ZIKQuery : NSObject

/**
 The CAQL query language used to filter devices.
 */
@property (nonatomic, retain, readonly) NSString *query;

/**
 The particular server that devices will be queried for devices.
 */
@property (nonatomic, retain, readonly) ZIKServer *server;

///---------------------------
/// @name Initialization
///---------------------------

/**
 Initializes a `ZIKQuery` with the specified query and `ZIKServer` object.
 
 This is the designated initializer.
 
 @param query The base CAQL query used to filter devices.
 @param server The server to perform the query on.
 
 @return The newly-initialized `ZIKStreamEntry` object.
 */
+ (instancetype) queryFromString:(NSString *)query fromServer:(ZIKServer *)server;

/**
 Initializes a `ZIKQuery` to find all devices with the specified `ZIKServer` object.
 
 @param server The server to perform the query on.
 
 @return The newly-initialized `ZIKQuery` object.
 */
+ (instancetype) allDevicesFromServer:(ZIKServer *)server;

/**
 Initializes a `ZIKQuery` to find all devices on all servers.
 
 @return The newly-initialized `ZIKQuery` object.
 */
+ (instancetype) allDevicesFromAllServers;

/**
 Initializes a `ZIKQuery` with the specified query to run on all servers.
 
 @param query The base CAQL query used to filter devices.
 
 @return The newly-initialized `ZIKQuery` object.
 */
+ (instancetype) queryFromStringOnAllServers:(NSString *)query;

/**
 Initializes a `ZIKQuery` with the specified query and `ZIKServer` object.
 
 @param query The base CAQL query used to filter devices.
 @param server The server to perform the query on.
 
 @return The newly-initialized `ZIKStreamEntry` object.
 */
- (instancetype) initWithQuery:(NSString *)query andServer:(ZIKServer *)server;

@end
