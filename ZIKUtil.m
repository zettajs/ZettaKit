//
//  ZIKUtil.m
//  ReactiveLearning
//
//  Created by Matthew Dobson on 4/8/15.
//  Copyright (c) 2015 Matthew Dobson. All rights reserved.
//

#import "ZIKUtil.h"

@implementation ZIKUtil

+ (NSString *) urlFormEncodeDictionary:(NSDictionary *) data {
    NSMutableArray *encodedParams = [[NSMutableArray alloc] init];
    
    for (id key in data) {
        NSString *keyVal = (NSString *)key;
        NSString *valVal = nil;
        id value = [data objectForKey:key];
        if ([value isMemberOfClass:[NSNumber class]]) {
            valVal = [value stringValue];
        } else {
            valVal = (NSString*)value;
        }
        
        [encodedParams addObject:[NSString stringWithFormat:@"%@=%@", keyVal, valVal]];
    }
    
    return [[encodedParams componentsJoinedByString:@"&"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

@end
