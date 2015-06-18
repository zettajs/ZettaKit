//
//  ZIKDevice.m
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


#import "ZIKDevice.h"
#import "ZIKUtil.h"
#import "ZIKLink.h"
#import "ZIKTransition.h"
#import "ZIKSession.h"

@interface ZIKDevice ()

@property (nonatomic, retain) NSArray *streams;
@property (nonatomic, retain) NSDictionary *properties;
@property (nonatomic, retain) NSDictionary *sirenData;

@property (nonatomic, retain, readwrite) NSString *uuid;
@property (nonatomic, retain, readwrite) NSString *type;
@property (nonatomic, retain, readwrite) NSString *name;
@property (nonatomic, retain, readwrite) NSString *state;
@property (nonatomic, retain, readwrite) NSArray *transitions;
@property (nonatomic, retain, readwrite) NSArray *links;

- (NSURLRequest *) requestForTransition:(NSString *)name withArgs:(NSDictionary *)args;

@end

@implementation ZIKDevice

+ (instancetype) initWithDictionary:(NSDictionary *)data {
    return [[ZIKDevice alloc] initWithDictionary:data];
}

- (instancetype) initWithDictionary:(NSDictionary *)data {
    if (self = [super init]) {
        [self refresh:data];
    }
    return self;
}

- (NSString *) description {
    return [NSString stringWithFormat:@"<ZIKDevice: %@ : %@ : %@>", self.uuid, self.type, self.name];
}

- (ZIKStream *) stream:(NSString*) name {
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"title == %@", name];
    NSArray *filteredStreams = [self.streams filteredArrayUsingPredicate:pred];
    if ([filteredStreams count] != 0) {
        ZIKLink *entry = filteredStreams[0];
        return [[ZIKStream alloc] initWithLink:entry];
    } else {
        return nil;
    }
}

- (void) refresh:(NSDictionary *)data {
    self.sirenData = data;
    if ([data objectForKey:@"properties"] != nil) {
        self.properties = [data objectForKey:@"properties"];
        self.type = self.properties[@"type"];
        self.name = self.properties[@"name"];
        self.uuid = self.properties[@"id"];
        self.state = self.properties[@"state"];
    }
    
    if ([data objectForKey:@"links"] != nil) {
        NSMutableArray *links = [[NSMutableArray alloc] init];
        NSMutableArray *streams = [[NSMutableArray alloc] init];
        for (NSDictionary *linkData in data[@"links"]) {
            ZIKLink *link = [ZIKLink initWithDictionary:linkData];
            if ([link hasRel:@"monitor"]) {
                [streams addObject:link];
            }
            [links addObject:link];
        }
        self.streams = [NSArray arrayWithArray:streams];
        self.links = [NSArray arrayWithArray:links];
    }
    
    if (![[data objectForKey:@"actions"] isEqual:[NSNull null]]) {
        NSMutableArray *transitions = [[NSMutableArray alloc] init];
        for (NSDictionary *actionData in data[@"actions"]) {
            ZIKTransition *trans = [ZIKTransition initWithDictionary:actionData];
            [transitions addObject:trans];
        }
        self.transitions = transitions;
    } else {
        self.transitions = @[];
    }
}

- (RACSignal *) transition:(NSString *)name {
    return [self transition:name withArguments:@{}];
}

- (void) transition:(NSString *)name andCompletion:(CompletionBlock)block {
    [self transition:name withArguments:@{} andCompletion:block];
}

- (RACSignal *) transition:(NSString *)name withArguments:(NSDictionary *)args {
    NSURLRequest *req = [self requestForTransition:name withArgs:args];
    ZIKSession *sharedSession = [ZIKSession sharedSession];
    return [sharedSession taskForRequest:req];
}

- (NSURLRequest *) requestForTransition:(NSString *)name withArgs:(NSDictionary *)args {
    //Setup transition args
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:args];
    [dict setObject:name forKey:@"action"];
    NSString * data = [ZIKUtil urlFormEncodeDictionary:dict];
    
    //Ensure action is on representation
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"name = %@", name];
    NSArray *transitions = [self.transitions filteredArrayUsingPredicate:pred];
    ZIKTransition *transition = transitions[0];
    NSMutableURLRequest *request = [transition createRequestForTransition];
    
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[data length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:[data dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
}

- (void) transition:(NSString *)name withArguments:(NSDictionary *)args andCompletion:(CompletionBlock)block {
    
    ZIKSession *sharedSession = [ZIKSession sharedSession];
    
    NSURLRequest *request = [self requestForTransition:name withArgs:args];
    
    RACSignal *task = [sharedSession taskForRequest:request];
    
    RACSignal *deviceMap = [task map:^id(NSDictionary *value) {
        return [ZIKDevice initWithDictionary:value];
    }];
    
    RACSignal *singleDevice = [deviceMap take:1];
    
    [singleDevice subscribeNext:^(id x) {
        block(nil, x);
    } error:^(NSError *error) {
        block(error, nil);
    }];
    
}

@end
