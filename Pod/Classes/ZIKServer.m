//
//  ZIKServer.m
//  ReactiveLearning
//
//  Created by Matthew Dobson on 4/7/15.
//  Copyright (c) 2015 Matthew Dobson. All rights reserved.
//

#import "ZIKServer.h"
#import "ZIKLink.h"
#import "ZIKDevice.h"
#import "ZIKSession.h"

@interface ZIKServer ()

@property (nonatomic, retain) NSDictionary *sirenData;
@property (nonatomic, retain, readwrite) NSArray *devices;
@property (nonatomic, retain, readwrite) NSString *name;
@property (nonatomic, retain, readwrite) NSArray *links;

@end

@implementation ZIKServer

+ (instancetype) initWithDictionary:(NSDictionary *)data {
    return [[ZIKServer alloc] initWithDictionary:data];
}

- (instancetype) initWithDictionary:(NSDictionary *)data {
    if (self = [super init]) {
        if([data objectForKey:@"properties"] != nil) {
            NSDictionary *properties = data[@"properties"];
            if([properties objectForKey:@"name"]) {
                self.name = properties[@"name"];
            }
        }
        
        if ([data objectForKey:@"entities"] != nil) {
            NSMutableArray *devices = [[NSMutableArray alloc] init];
            for (NSDictionary *deviceData in data[@"entities"]) {
                [devices addObject:[ZIKDevice initWithDictionary:deviceData]];
            }
            self.devices = [NSArray arrayWithArray:devices];
        }
        
        NSMutableArray *links = [[NSMutableArray alloc] init];
        for (NSDictionary *linkData in data[@"links"]) {
            [links addObject:[ZIKLink initWithDictionary:linkData]];
        }
        self.links = [NSArray arrayWithArray:links];
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<ZIKServer: %@>", self.name];
}

- (RACSignal *) fetch {
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"rel CONTIANS %@", @"self"];
    NSArray *filteredLinks = [self.links filteredArrayUsingPredicate:pred];
    ZIKLink *selfLink = filteredLinks[0];
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:selfLink.href]];
    RACSignal *fetchSignal = [[ZIKSession sharedSession] taskForRequest:req];
    return [fetchSignal map:^id(NSDictionary *value) {
        return [ZIKServer initWithDictionary:value];
    }];
}

- (void) fetchWithCompletion:(ServerCompletionBlock)block {
    RACSignal *fetchSignal = [self fetch];
    
    RACSignal *singleServer = [fetchSignal take:1];
    
    [singleServer subscribeNext:^(id x) {
        block(nil, x);
    } error:^(NSError *error) {
        block(error, nil);
    }];
}

@end
