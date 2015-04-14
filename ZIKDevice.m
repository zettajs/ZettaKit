//
//  ZIKDevice.m
//  ReactiveLearning
//
//  Created by Matthew Dobson on 4/7/15.
//  Copyright (c) 2015 Matthew Dobson. All rights reserved.
//

#import "ZIKDevice.h"
#import "ZIKUtil.h"
#import "ZIKLink.h"
#import "ZIKTransition.h"

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

@end

@implementation ZIKDevice

+ (instancetype) initWithDictionary:(NSDictionary *)data {
    return [[ZIKDevice alloc] initWithDictionary:data];
}

- (id) initWithDictionary:(NSDictionary *)data {
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
    if ([data objectForKey:@"properties"]) {
        self.properties = [data objectForKey:@"properties"];
        self.type = self.properties[@"type"];
        self.name = self.properties[@"name"];
        self.uuid = self.properties[@"id"];
        self.state = self.properties[@"state"];
    }
    
    if ([data objectForKey:@"links"]) {
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

- (void) transition:(NSString *)name {
    [self transition:name withArguments:@{} andCompletion:nil];
}

- (void) transition:(NSString *)name andCompletion:(CompletionBlock)block {
    [self transition:name withArguments:@{} andCompletion:block];
}

- (void) transition:(NSString *)name withArguments:(NSDictionary *)args {
    [self transition:name withArguments:args andCompletion:nil];
}

- (void) transition:(NSString *)name withArguments:(NSDictionary *)args andCompletion:(CompletionBlock)block {
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
    
    //Prevent them retain cycles
    __block ZIKDevice *device = self;
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
               completionHandler:^(NSData *responseData, NSURLResponse *response, NSError *error) {
                   NSDictionary *data = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
                   [device refresh:data];
                   if (block != nil) {
                       block(error, device, response);
                   }
    }];
    [task resume];
}

@end
