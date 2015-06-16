//
//  ZIKRoot.m
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


#import "ZIKRoot.h"
#import "ZIKLink.h"

@interface ZIKRoot ()

@property (nonatomic, retain) ZIKLink *href;

@end

@implementation ZIKRoot

+ (instancetype) initWithDictionary:(NSDictionary *)data {
    return [[ZIKRoot alloc] initWithDictionary:data];
}

- (id) initWithDictionary:(NSDictionary *)data {
    if (self = [super init]) {
        if ([data objectForKey:@"links"]) {
            NSMutableArray *links = [[NSMutableArray alloc] init];
            for (NSDictionary *linkData in data[@"links"]) {
                ZIKLink *link = [ZIKLink initWithDictionary:linkData];
                if ([link isSelf]) {
                    self.href = link;
                }
                [links addObject:link];
            }
            
            self.links = [NSArray arrayWithArray:links];
        }
        
        if ([data objectForKey:@"actions"]) {
            self.actions = data[@"actions"];
        }
        
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<ZIKRoot: %@>", self.href];
}

@end
