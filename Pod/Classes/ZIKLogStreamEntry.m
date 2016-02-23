//
//  ZIKLogStreamEntry.m
//  ReactiveLearning
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


#import "ZIKLogStreamEntry.h"

@interface ZIKLogStreamEntry ()

@property (nonatomic, retain, readwrite) NSString *topic;
@property (nonatomic, retain, readwrite) NSNumber *timestamp;
@property (nonatomic, retain, readwrite) NSString *transition;
@property (nonatomic, retain, readwrite) NSString *deviceState;
@property (nonatomic, retain, readwrite) NSDictionary *inputs;

@end

@implementation ZIKLogStreamEntry

- (instancetype) initWithDictionary:(NSDictionary *)data {
    if (self = [super init]) {
        self.timestamp = data[@"timestamp"];
        self.topic = data[@"topic"];
        NSDictionary *properties = data[@"properties"];
        self.deviceState = properties[@"state"];
        self.transition = data[@"transition"];
        
        if(data[@"inputs"]) {
            self.inputs = data[@"inputs"];
        } else {
            self.inputs = @{};
        }
    }
    return self;
}

+ (instancetype) initWithDictionary:(NSDictionary *)data {
    return [[ZIKLogStreamEntry alloc] initWithDictionary:data];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<ZIKStreamEntry: %@ = %@>", self.topic, self.deviceState];
}
@end
