//
//  ZIKSession.m
//  ReactiveLearning
//
//  Created by Matthew Dobson on 4/3/15.
//  Copyright (c) 2015 Matthew Dobson. All rights reserved.
//

#import "ZIKSession.h"
#import "ZIKRoot.h"
#import "ZIKServer.h"
#import "ZIKDevice.h"
#import "ZIKUtil.h"
#import "ZIKLink.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface ZIKSession()

typedef void (^DeviceQueryCompletion)(int count, RACSignal *devicesObservable);

@property (nonatomic, retain, readwrite) NSURL *apiEndpoint;

- (RACSignal *) get:(NSURL *)url;
- (RACSignal *) queryRequest:(ZIKQuery *)query;
- (RACSignal *) load;

@end

@implementation ZIKSession

+(instancetype) sharedSession {
    static dispatch_once_t p = 0;
    
    __strong static id _sharedObject = nil;
    
    dispatch_once(&p, ^{
        _sharedObject = [[self alloc] init];
    });
    
    return _sharedObject;
}

- (RACSignal *) get:(NSURL *)url {
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            NSDictionary *body = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            [subscriber sendNext:body];
            [subscriber sendCompleted];
        }];
        [task resume];
        return nil;
    }];
    
    return signal;
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
        return [value hasRel:@"http://rels.zettajs.io/server"] || [value hasRel:@"http://rels.zettajs.io/peer"];
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

@end
