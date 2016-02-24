//
//  ZIKQueryResponse.m
//  Pods
//
//  Created by Matthew Dobson on 2/17/16.
//
//

#import "ZIKQueryResponse.h"
#import "ZIKStream.h"
#import "ZIKLink.h"
#import "ZIKDevice.h"

@interface ZIKQueryResponse()

@property (nonatomic, retain, readwrite) NSArray *links;
@property (nonatomic, retain, readwrite) NSString *server;
@property (nonatomic, retain, readwrite) NSString *ql;

@end

@implementation ZIKQueryResponse

-(instancetype) initWithDictionary:(NSDictionary *) data {
    NSLog(@"Props: %@", data[@"properties"]);
    if (self = [super init]) {
        self.server = data[@"properties"][@"name"];
        self.ql = data[@"properties"][@"ql"];
        NSMutableArray *links = [[NSMutableArray alloc] init];
        
        for (NSDictionary *linkData in data[@"links"]) {
            ZIKLink *link = [ZIKLink initWithDictionary:linkData];
            [links addObject:link];
        }
        
        self.links = [NSArray arrayWithArray:links];
        
        if ([data objectForKey:@"entities"] != nil) {
            NSMutableArray *devices = [[NSMutableArray alloc] init];
            for (NSDictionary *deviceData in data[@"entities"]) {
                [devices addObject:[ZIKDevice initWithDictionary:deviceData]];
            }
            self.devices = [NSArray arrayWithArray:devices];
        }
    }
    
    return self;
}

+(instancetype) initWithDictionary:(NSDictionary *) data {
    return [[ZIKQueryResponse alloc] initWithDictionary:data];
}

-(ZIKStream *) resultsStream {
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"rel CONTAINS %@", @"http://rels.zettajs.io/query"];
    NSArray *filteredStreams = [self.links filteredArrayUsingPredicate:pred];
    if ([filteredStreams count] != 0) {
        ZIKLink *entry = filteredStreams[0];
        return [ZIKStream initWithLink:entry];
    } else {
        return nil;
    }
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<ZIKQueryResponse %@ against %@>", self.ql, self.server];
}


@end