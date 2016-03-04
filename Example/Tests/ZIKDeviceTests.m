#import "ZIKDevice.h"

SpecBegin(ZIKDevice)


NSDictionary *properties = @{@"id": @"a2f62fda-4a8c-4433-ac49-721ffac92ce4",
                             @"type": @"led",
                             @"state": @"off"};

NSDictionary *sensorProperties = @{@"id": @"a2f62fda-4a8c-4433-ac49-721ffac92ce4",
                             @"type": @"photocell"};
NSArray *links = @[
                       @{
                           @"rel": @[ @"self"],
                           @"href": @"http://zt-1-mdobs.herokuapp.com/servers/67d6368a-7360-4b61-9d97-403f9f43f092/devices/a2f62fda-4a8c-4433-ac49-721ffac92ce4"
                       },
                       @{
                           @"title": @"67d6368a-7360-4b61-9d97-403f9f43f092",
                           @"rel": @[ @"up", @"http://rels.zettajs.io/server"],
                           @"href": @"http://zt-1-mdobs.herokuapp.com/servers/67d6368a-7360-4b61-9d97-403f9f43f092"
                       },
                       @{
                           @"title": @"state",
                           @"rel": @[ @"monitor", @"http://rels.zettajs.io/object-stream" ],
                           @"href": @"ws://zt-1-mdobs.herokuapp.com/servers/67d6368a-7360-4b61-9d97-403f9f43f092/events?topic=led%2Fa2f62fda-4a8c-4433-ac49-721ffac92ce4%2Fstate"
                       },
                       @{
                           @"title": @"logs",
                           @"rel": @[ @"monitor", @"http://rels.zettajs.io/object-stream" ],
                           @"href": @"ws://zt-1-mdobs.herokuapp.com/servers/67d6368a-7360-4b61-9d97-403f9f43f092/events?topic=led%2Fa2f62fda-4a8c-4433-ac49-721ffac92ce4%2Flogs"
                       }];
NSArray *actions = @[@{
                              @"name": @"turn-on",
                              @"method": @"POST",
                              @"href": @"http://zt-1-mdobs.herokuapp.com/servers/67d6368a-7360-4b61-9d97-403f9f43f092/devices/a2f62fda-4a8c-4433-ac49-721ffac92ce4",
                              @"fields": @[ @{ @"name": @"action", @"type": @"hidden", @"value": @"turn-on" } ]
                        }];
;

NSDictionary *actuator = @{@"properties": properties, @"links": links, @"actions": actions};
NSDictionary *sensor = @{@"actions": @[], @"links": links, @"properties": sensorProperties};

NSDictionary *entry = @{@"topic":@"input/205c8651-2793-4e97-94a9-ce0eb61e2cb3/logs",@"timestamp":@1456430816996,@"transition":@"input",@"input":@[@{@"name":@"t1",@"value":@"1"},@{@"name":@"t2",@"value":@"2"}],@"properties":@{@"id":@"205c8651-2793-4e97-94a9-ce0eb61e2cb3",@"type":@"input",@"state":@"on"},@"actions":@[@{@"class":@[@"transition"],@"name":@"input",@"method":@"POST",@"href":@"http://localhost:1338/servers/cloud/devices/205c8651-2793-4e97-94a9-ce0eb61e2cb3",@"fields":@[@{@"type":@"text",@"name":@"t1"},@{@"type":@"text",@"name":@"t2"},@{@"name":@"action",@"type":@"hidden",@"value":@"input"}]}]};

describe(@"ZIKDevice", ^{
    describe(@"Initialization", ^{
        it(@"Can be initialized with a dictionary", ^{
            ZIKDevice *device = [ZIKDevice initWithDictionary:actuator];
            expect(device.uuid).to.equal(@"a2f62fda-4a8c-4433-ac49-721ffac92ce4");
            expect(device.type).to.equal(@"led");
            expect(device.state).to.equal(@"off");
            expect(device.name).to.equal(nil);
            expect(device.transitions.count).to.equal(@1);
            expect(device.links.count).to.equal(@4);
        });
        
        it(@"Can be initialized with another dictionary method", ^{
            ZIKDevice *device = [[ZIKDevice alloc] initWithDictionary:actuator];
            expect(device.uuid).to.equal(@"a2f62fda-4a8c-4433-ac49-721ffac92ce4");
            expect(device.type).to.equal(@"led");
            expect(device.state).to.equal(@"off");
        });
        
        it(@"Can be initialized with a dictionary when a sensor", ^{
            ZIKDevice *device = [ZIKDevice initWithDictionary:sensor];
            expect(device.uuid).to.equal(@"a2f62fda-4a8c-4433-ac49-721ffac92ce4");
            expect(device.type).to.equal(@"photocell");
            expect(device.state).to.equal(nil);
            expect(device.name).to.equal(nil);
        });
        
    });
    
    describe(@"streams", ^{
        it(@"Will return all streams that can be subscribed to.", ^{
            ZIKDevice *device = [ZIKDevice initWithDictionary:actuator];
            NSArray *streams = [device getAllStreams];
            expect([streams count]).to.equal(2);
        });
    });
    
    it(@"ZIKDevice refresh with a log entry.", ^{
        ZIKDevice *device = [ZIKDevice initWithDictionary:actuator];
        ZIKLogStreamEntry *deviceEntry = [ZIKLogStreamEntry initWithDictionary:entry];
        [device refreshWithLogEntry:deviceEntry];
        expect(device.transitions.count).to.equal(1);
        expect(device.properties[@"type"]).to.equal(@"input");
        expect(device.state).to.equal(@"on");
    });
});

SpecEnd