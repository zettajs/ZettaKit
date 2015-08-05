//
//  ZIKUtil.m
//  ReactiveLearning
//
//  Created by Matthew Dobson on 4/8/15.
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
    
    NSString *encodedParamsString = [[encodedParams componentsJoinedByString:@"&"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return encodedParamsString;
}

+ (NSString *) generateRelForString:(NSString *)string {
    return [NSString stringWithFormat:@"http://rels.zettajs.io/%@", string];
}

@end
