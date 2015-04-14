//
//  ZIKUtil.h
//  ReactiveLearning
//
//  Created by Matthew Dobson on 4/8/15.
//  Copyright (c) 2015 Matthew Dobson. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 The `ZIKUtil` class is general helper utilities for the SDK.
 */
@interface ZIKUtil : NSObject

/**
 Creates a application/x-www-form-urlencoded string from an `NSDictionary`.
 
 @param data The `NSDictionary` to encode into a form string.
 
 @return a string of key values that conforms to the application/x-www-form-urlencoded media type.
 */
+ (NSString *) urlFormEncodeDictionary:(NSDictionary *) data;

@end
