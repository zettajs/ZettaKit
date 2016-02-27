//
//  ZIKLogStreamEntryTests.m
//  ZettaKit
//
//  Created by Matthew Dobson on 2/25/16.
//  Copyright © 2016 Matthew Dobson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZIKLogStreamEntry.h"
#import "ZIKTransition.h"

SpecBegin(ZIKLogStreamEntry)

NSDictionary *data = @{@"topic":@"input/205c8651-2793-4e97-94a9-ce0eb61e2cb3/logs",@"timestamp":@1456430816996,@"transition":@"input",@"input":@[@{@"name":@"t1",@"value":@"1"},@{@"name":@"t2",@"value":@"2"}],@"properties":@{@"id":@"205c8651-2793-4e97-94a9-ce0eb61e2cb3",@"type":@"input",@"state":@"on"},@"actions":@[@{@"class":@[@"transition"],@"name":@"input",@"method":@"POST",@"href":@"http://localhost:1338/servers/cloud/devices/205c8651-2793-4e97-94a9-ce0eb61e2cb3",@"fields":@[@{@"type":@"text",@"name":@"t1"},@{@"type":@"text",@"name":@"t2"},@{@"name":@"action",@"type":@"hidden",@"value":@"input"}]}]};

NSDictionary *data2 = @{@"topic":@"input/205c8651-2793-4e97-94a9-ce0eb61e2cb3/logs",@"timestamp":@1456430816996,@"transition":@"input",@"input":@[@{@"name":@"t1",@"value":@"1"},@{@"name":@"t2",@"value":@"2"}],@"properties":@{@"id":@"205c8651-2793-4e97-94a9-ce0eb61e2cb3",@"type":@"input",@"state":@"on"},@"actions":@[]};

NSDictionary *data3 = @{@"topic":@"input/205c8651-2793-4e97-94a9-ce0eb61e2cb3/logs",@"timestamp":@1456430816996,@"transition":@"input",@"properties":@{@"id":@"205c8651-2793-4e97-94a9-ce0eb61e2cb3",@"type":@"input",@"state":@"on"}};

describe(@"ZIKLogStreamEntry", ^{
    it(@"Initializes inputs and actions properly when they are present", ^{
        ZIKLogStreamEntry *entry = [ZIKLogStreamEntry initWithDictionary:data];
        expect(entry.actions.count).to.equal(1);
        expect(entry.inputs.count).to.equal(2);
        ZIKTransition *transition = entry.actions[0];
        expect(transition.name).to.equal(@"input");
    });
    
    it(@"Initializes inputs and actions properly when actions are empty", ^{
        ZIKLogStreamEntry *entry = [ZIKLogStreamEntry initWithDictionary:data2];
        expect(entry.actions.count).to.equal(0);
        expect(entry.inputs.count).to.equal(2);
    });
    
    it(@"Initializes inputs and actions properly when actions and input are not present", ^{
        ZIKLogStreamEntry *entry = [ZIKLogStreamEntry initWithDictionary:data3];
        expect(entry.actions.count).to.equal(0);
        expect(entry.inputs.count).to.equal(0);
    });
    
});

SpecEnd