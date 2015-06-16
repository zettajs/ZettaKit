//
//  ZIKStreamEntry.m
//  ReactiveLearning
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


#import "ZIKStreamEntry.h"

@interface ZIKStreamEntry ()

@property (nonatomic, retain, readwrite) NSString *topic;
@property (nonatomic, retain, readwrite) NSNumber *timestamp;
@property (nonatomic, retain, readwrite) id data;

@end

@implementation ZIKStreamEntry

+ (instancetype) initWithDictionary:(NSDictionary *)data {
    return [[ZIKStreamEntry alloc] initWithDictionary:data];
}

- (id) initWithDictionary:(NSDictionary *)data {
    if (self = [super init]) {
        NSNumber *timestamp = [data objectForKey:@"timestamp"];
        id dataEntry = [data objectForKey:@"data"];
        NSString *topic = [data objectForKey:@"topic"];
        if (timestamp) {
            self.timestamp = timestamp;
        }
        
        if (dataEntry) {
            self.data = dataEntry;
        }
        
        if (topic) {
            self.topic = topic;
        }
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<ZIKStreamEntry: %@ = %@>", self.topic, self.data];
}

@end
