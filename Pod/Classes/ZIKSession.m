//
//  ZIKSession.m
//  ReactiveLearning
//
//  Created by Matthew Dobson on 4/3/15.
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


#import "ZIKSession.h"
#import "ZIKRoot.h"
#import "ZIKServer.h"
#import "ZIKDevice.h"
#import "ZIKUtil.h"
#import "ZIKLink.h"
#import "ZIKSpdyDelegate.h"
#import "ZIKPubSubBroker.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "include/ispdy.h"

@interface ZIKSession()

typedef void (^DeviceQueryCompletion)(int count, RACSignal *devicesObservable);

@property (nonatomic, retain, readwrite) NSURL *apiEndpoint;
@property (nonatomic) BOOL isSpdy;
@property (nonatomic, retain) ISpdy *spdyConnection;
@property (nonatomic, retain) NSMutableDictionary *headers;

- (RACSignal *) get:(NSURL *)url;
- (RACSignal *) queryRequest:(ZIKQuery *)query;
- (RACSignal *) load;

@end

@implementation ZIKSession

- (void) useSpdyWithURL:(NSURL*)spdyEndpoint {
    self.isSpdy = YES;
    self.apiEndpoint = spdyEndpoint;
    self.spdyConnection = [[ISpdy alloc] init:kISpdyV3 host:spdyEndpoint.host port:[spdyEndpoint.port integerValue] secure:NO];
    [self.spdyConnection setDelegate:[ZIKPubSubBroker sharedBroker]];
    [self.spdyConnection connect];
}

- (void) endSpdySession {
    if (self.isSpdy) {
        [self.spdyConnection close];
        self.apiEndpoint = nil;
        self.isSpdy = NO;
    }
}

- (BOOL) usingSpdy {
    return self.isSpdy;
}

- (void) spdyPushTaskWithRequest:(ISpdyRequest *)request {
    [self.spdyConnection send:request];
    [request end];
}

+(instancetype) sharedSession {
    static dispatch_once_t p = 0;
    
    __strong static ZIKSession *_sharedObject = nil;
    
    dispatch_once(&p, ^{
        _sharedObject = [[self alloc] init];
        _sharedObject.isSpdy = NO;
        _sharedObject.headers = [[NSMutableDictionary alloc] init];
    });
    
    return _sharedObject;
}

- (RACSignal *) get:(NSURL *)url {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    return [self taskForRequest:request];
}

- (RACSignal *) queryRequest:(ZIKQuery *)query {
    RACSignal *root = [self root:self.apiEndpoint];
    RACSignal *queryAction = [root map:^id(ZIKRoot *apiRoot) {
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"name = %@", @"query-devices"];
        NSArray *queryDevicesActions = [apiRoot.actions filteredArrayUsingPredicate:pred];
        return queryDevicesActions[0];
    }];
    
    RACSignal *queryResult = [queryAction map:^id(NSDictionary *value) {
        NSString *href = value[@"href"];
        NSDictionary *data = @{@"ql": query.query, @"server": query.server.name};
        NSString *encodedParams = [ZIKUtil urlFormEncodeDictionary:data];
        NSString *endpoint = [NSString stringWithFormat:@"%@?%@", href, encodedParams];
        return [self get:[NSURL URLWithString:endpoint]];
    }];
    
    RACSignal * flatQueryResults = [queryResult flatten];
    
    RACSignal *serverQueryResult = [flatQueryResults map:^id(NSDictionary *value) {
        ZIKServer *server = [ZIKServer initWithDictionary:value];
        return server;
    }];
    
    RACSignal *devices = [self devices:serverQueryResult];
    
    return devices;
}

- (RACSignal *) root:(NSURL *)url {
    RACSignal *rootResponse = [self get:url];
    
    RACSignal *root = [rootResponse map:^id(NSDictionary *value) {
        return [ZIKRoot initWithDictionary:value];
    }];
    
    return root;
}

- (RACSignal *) load:(NSURL *)url {
    self.apiEndpoint = url;
    return [self load];
}

- (RACSignal *) load {
    RACSignal *apiResponse = [self get:self.apiEndpoint];
    return apiResponse;
}

- (RACSignal *) servers:(RACSignal *)rootObservable {
    @weakify(self)
    RACSignal *linkList = [rootObservable map:^id(ZIKRoot *value) {
        return value.links.rac_sequence.signal;
    }];
    
    RACSignal * flatLinks = [linkList flatten];
    
    RACSignal * serverLinks = [flatLinks filter:^BOOL(ZIKLink *value) {
        return [value hasRel:[ZIKUtil generateRelForString:@"server"]];
    }];
    
    RACSignal * serverResponses = [serverLinks map:^id(ZIKLink *value) {
        @strongify(self)
        return [self get:[NSURL URLWithString:value.href]];
    }];
    
    RACSignal *flatResponses = [serverResponses flatten];
    
    RACSignal *serverObjectMapping = [flatResponses map:^id(NSDictionary *value) {
        return [ZIKServer initWithDictionary:value];
    }];
    return serverObjectMapping;
}

- (RACSignal *) devices:(RACSignal *)serverObservable {
    @weakify(self)
    
    RACSignal *entities = [serverObservable map:^id(ZIKServer *value) {
        return value.devices.rac_sequence.signal;
    }];
    
    RACSignal *flatEntities = [entities flatten];
    
    RACSignal *deviceLinks = [flatEntities map:^id(ZIKDevice *value) {
        return value.links.rac_sequence.signal;
    }];
    
    RACSignal *flatDeviceLinks = [deviceLinks flatten];
    
    RACSignal *filteredDeviceSelfLinks = [flatDeviceLinks filter:^BOOL(ZIKLink *value) {
        return [value isSelf];
    }];
    
    RACSignal *deviceResponses = [filteredDeviceSelfLinks map:^id(ZIKLink *value) {
        @strongify(self)
        return [self get:[NSURL URLWithString:value.href]];
    }];
    
    RACSignal *flatResponses = [deviceResponses flatten];
    
    RACSignal *deviceObjectMapping = [flatResponses map:^id(NSDictionary *value) {
        return [ZIKDevice initWithDictionary:value];
    }];
    
    return deviceObjectMapping;
}



- (void) getServerByName:(NSString *)name withCompletion:(ServerCompletionBlock)block {
    RACSignal *root = [self root:self.apiEndpoint];
    RACSignal *servers = [self servers:root];
    RACSignal *namedServer = [servers filter:^BOOL(ZIKServer *server) {
        return [name isEqualToString:server.name];
    }];
    RACSignal *takeFirstServer = [namedServer take:1];
    [takeFirstServer subscribeNext:^(id x) {
        block(nil, x);
    }];
}

- (void) queryDevices:(NSArray *)queries withCompletion:(DevicesCompletionBlock)block {
    NSMutableArray *queryRequests = [[NSMutableArray alloc] init];
    for (ZIKQuery *query in queries) {
        RACSignal *sig = [self queryRequest:query];
        [queryRequests addObject:sig];
    }
    
    RACSignal *merged = [[RACSignal merge:queryRequests] collect];
    
    [merged subscribeNext:^(id x) {
        block(nil, x);
    }];
    
}

- (RACSignal *) queryDevices:(NSArray *)queries {
    NSMutableArray *queryRequests = [[NSMutableArray alloc] init];
    for (ZIKQuery *query in queries) {
        RACSignal *sig = [self queryRequest:query];
        [queryRequests addObject:sig];
    }
    
    RACSignal *merged = [RACSignal merge:queryRequests];
    return merged;
}

- (RACSignal *) getServerByName:(NSString *)name {
    RACSignal *root = [self root:self.apiEndpoint];
    RACSignal *servers = [self servers:root];
    RACSignal *namedServer = [servers filter:^BOOL(ZIKServer *value) {
        return [value.name isEqualToString:name];
    }];
    return namedServer;
}

- (RACSignal *)HTTPTaskForRequest:(NSURLRequest *)req {
    NSMutableURLRequest *mutableRequest = [req mutableCopy];
    RACSignal *taskSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSURLSession *sharedSession = [NSURLSession sharedSession];
        for (id key in self.headers) {
            NSString *keyVal = (NSString *)key;
            NSString *valVal = nil;
            id value = [self.headers objectForKey:key];
            if ([value isMemberOfClass:[NSNumber class]]) {
                valVal = [value stringValue];
            } else {
                valVal = (NSString*)value;
            }
            [mutableRequest setValue:valVal forHTTPHeaderField:keyVal];
        }
        [[sharedSession dataTaskWithRequest:mutableRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
            if (error != nil) {
                [subscriber sendError:error];
                [subscriber sendCompleted];
            } else {
                if ([res statusCode] != 200) {
                    [subscriber sendError:[[NSError alloc] initWithDomain:@"org.zettakit" code:404 userInfo:@{@"message": @"body length 0"}]];
                    [subscriber sendCompleted];
                } else if ([data length] == 0) {
                    [subscriber sendError:[[NSError alloc] initWithDomain:@"org.zettakit" code:404 userInfo:@{@"message": @"body length 0"}]];
                    [subscriber sendCompleted];
                } else {
                    NSError *err = nil;
                    NSDictionary *parsedData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
                    if (err != nil) {
                        [subscriber sendError:err];
                        [subscriber sendCompleted];
                    } else {
                        [subscriber sendNext:parsedData];
                        [subscriber sendCompleted];
                    }
                }
            }
        }] resume];
        return nil;
    }];
    return taskSignal;
}

- (RACSignal *) SPDYTaskForRequest:(NSURLRequest *)req {
    @weakify(self)
    RACSignal *taskSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self)
        ISpdyRequest *spdyReq = [[ISpdyRequest alloc] init:req.HTTPMethod url:req.URL.path];
        ZIKSpdyDelegate *delegate = [ZIKSpdyDelegate initWithCompletion:^(ISpdyError *error, NSDictionary *headers, NSData *data) {
            if (error != nil) {
                NSLog(@"ERROR: %@", error);
            } else {
                NSError *err = nil;
                if ([data length] != 0) {
                    NSDictionary *parsedData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
                    if (err != nil) {
                        [subscriber sendError:err];
                        [subscriber sendCompleted];
                    } else {
                        [subscriber sendNext:parsedData];
                        [subscriber sendCompleted];
                    }
                } else {
                }
            }
        }];
        spdyReq.delegate = delegate;
        [self.spdyConnection send:spdyReq];
        if (req.HTTPBody != nil) {
            NSDictionary *headers = @{@"Accept": @"application/vnd.siren+json", @"Content-Type": @"application/x-www-form-urlencoded", @"Content-Length":[NSNumber numberWithUnsignedInteger:[req.HTTPBody length]]};
            NSMutableDictionary *mergedHeaders = [[NSMutableDictionary alloc] init];
            [mergedHeaders addEntriesFromDictionary:self.headers];
            [mergedHeaders addEntriesFromDictionary:headers];
            [spdyReq setHeaders:mergedHeaders];
            [spdyReq writeData:req.HTTPBody];
            [spdyReq end];
        } else {
            NSDictionary *headers = @{@"Accept": @"application/vnd.siren+json"};
            [spdyReq setHeaders:headers];
            [spdyReq end];
        }
        return nil;
    }];
    return taskSignal;
}

- (RACSignal *) taskForRequest:(NSURLRequest *)req {
    if (self.isSpdy == YES) {
        return [self SPDYTaskForRequest:req];
    } else {
        return [self HTTPTaskForRequest:req];
    }
}

- (void) setHeaders:(NSDictionary *)headers {
    [self.headers addEntriesFromDictionary:headers];
}

- (void) setHeader:(NSString *)key forValue:(id)value {
    [self.headers setObject:value forKey:key];
}

- (void) unsetHeader:(NSString *)key {
    [self.headers removeObjectForKey:key];
}

@end
