//
//  ZIKServerTests.m
//  ZettaKit
//
//  Created by Matthew Dobson on 2/27/16.
//  Copyright © 2016 Matthew Dobson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZIKServer.h"

SpecBegin(ZIKServer)

describe(@"Server tests", ^{
    NSDictionary *data = @{@"class":@[@"server"],@"properties":@{@"name":@"cloud",@"foo":@"bar"},@"entities":@[@{@"class":@[@"device",@"input"],@"rel":@[@"http://rels.zettajs.io/device"],@"properties":@{@"id":@"a55e9cc4-4a26-471e-bc40-dbca30f963ef",@"type":@"input",@"state":@"on"},@"links":@[@{@"rel":@[@"self",@"edit"],@"href":@"http://localhost:1338/servers/cloud/devices/a55e9cc4-4a26-471e-bc40-dbca30f963ef"},@{@"rel":@[@"http://rels.zettajs.io/type",@"describedby"],@"href":@"http://localhost:1338/servers/cloud/meta/input"},@{@"title":@"cloud",@"rel":@[@"up",@"http://rels.zettajs.io/server"],@"href":@"http://localhost:1338/servers/cloud"}]}],@"actions":@[@{@"name":@"query-devices",@"method":@"GET",@"href":@"http://localhost:1338/servers/cloud",@"type":@"application/x-www-form-urlencoded",@"fields":@[@{@"name":@"ql",@"type":@"text"}]}],@"links":@[@{@"rel":@[@"self"],@"href":@"http://localhost:1338/servers/cloud"},@{@"rel":@[@"http://rels.zettajs.io/metadata"],@"href":@"http://localhost:1338/servers/cloud/meta"},@{@"rel":@[@"monitor"],@"href":@"ws://localhost:1338/servers/cloud/events?topic=logs"}]};
    
    it(@"initializes the server properly", ^{
        ZIKServer *server = [ZIKServer initWithDictionary:data];
        expect(server.properties[@"foo"]).to.equal(@"bar");
        expect(server.devices.count).to.equal(1);
        expect(server.properties[@"name"]).to.equal(@"cloud");
        expect(server.links.count).to.equal(3);
    });
});

SpecEnd

