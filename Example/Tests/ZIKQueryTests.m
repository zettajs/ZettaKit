//
//  ZIKQueryTests.m
//  ZettaKit
//
//  Created by Matthew Dobson on 2/23/16.
//  Copyright © 2016 Matthew Dobson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZIKQuery.h"

SpecBegin(ZIKQuery)

NSDictionary *data = @{
                       @"class":@[@"server"],
                       @"properties":@{
                               @"name":@"cloud"
                               },
                       @"entities":@[],
                       @"actions":@[
                               @{
                                   @"name":@"query-devices",
                                   @"method":@"GET",
                                   @"href":@"http://zetta-cloud-2.herokuapp.com/servers/cloud",
                                   @"type":@"application/x-www-form-urlencoded",
                                   @"fields":@[
                                           @{
                                               @"name":@"ql",
                                               @"type":@"text"
                                               }
                                           ]
                                   }],
                       @"links":@[
                               @{
                                   @"rel":@[@"self"],
                                   @"href":@"http://zetta-cloud-2.herokuapp.com/servers/cloud"
                                   },@{
                                   @"rel":@[@"http://rels.zettajs.io/metadata"],
                                   @"href":@"http://zetta-cloud-2.herokuapp.com/servers/cloud/meta"
                                   },
                               @{
                                   @"rel":@[@"monitor"],
                                   @"href":@"ws://zetta-cloud-2.herokuapp.com/servers/cloud/events?topic=logs"
                                   }
                               ]
                       };

describe(@"ZIKQuery", ^{
   it(@"Will initialize to a set server and ql", ^{
       ZIKQuery *query = [ZIKQuery queryFromString:@"where type = \"foo\"" fromServer:[ZIKServer initWithDictionary:data]];
       expect(query.server.name).to.equal(@"cloud");
       expect(query.query).to.equal(@"where type = \"foo\"");
   });
    
    it(@"Will query all servers", ^{
        ZIKQuery *query = [ZIKQuery queryFromStringOnAllServers:@"where type = \"foo\""];
        expect(query.server.name).to.equal(@"*");
        expect(query.query).to.equal(@"where type = \"foo\"");
    });
    
    it(@"Will query all devices", ^{
        ZIKQuery *query = [ZIKQuery allDevicesFromServer:[ZIKServer initWithDictionary:data]];
        expect(query.query).to.equal(@"where type is not none");
        expect(query.server.name).to.equal(@"cloud");
    });
    
    it(@"Will query for all devices and query all servers", ^{
        ZIKQuery *query = [ZIKQuery allDevicesFromAllServers];
        expect(query.query).to.equal(@"where type is not none");
        expect(query.server.name).to.equal(@"*");
    });
});

SpecEnd