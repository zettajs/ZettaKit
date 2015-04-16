#import "ZIKTransition.h"

SpecBegin(ZIKTransition)

NSDictionary *data = @{
                       @"name": @"turn-on",
                       @"method": @"POST",
                       @"href": @"http://zt-1-mdobs.herokuapp.com/servers/67d6368a-7360-4b61-9d97-403f9f43f092/devices/a2f62fda-4a8c-4433-ac49-721ffac92ce4",
                       @"fields": @[ @{ @"name": @"action", @"type": @"hidden", @"value": @"turn-on" } ]
                       };

describe(@"ZIKTransition", ^{
    describe(@"Initializers", ^{
        it(@"can initialize with the primary initializer", ^{
            ZIKTransition *transition = [ZIKTransition initWithDictionary:data];
            expect(transition.name).to.equal(@"turn-on");
        });
        
        it(@"can initialize with the secondary initializer", ^{
            ZIKTransition *transition = [[ZIKTransition alloc] initWithDictionary:data];
            expect(transition.name).to.equal(@"turn-on");
        });
    });
    
    describe(@"request construction", ^{
        it(@"will build the proper request", ^{
            ZIKTransition *transition = [ZIKTransition initWithDictionary:data];
            NSMutableURLRequest *req = [transition createRequestForTransition];
            expect(req.HTTPMethod).to.equal(@"POST");
            expect(req.URL).to.equal([NSURL URLWithString:@"http://zt-1-mdobs.herokuapp.com/servers/67d6368a-7360-4b61-9d97-403f9f43f092/devices/a2f62fda-4a8c-4433-ac49-721ffac92ce4"]);
            expect([req valueForHTTPHeaderField:@"Content-Type"]).to.equal(@"application/x-www-form-urlencoded");
        });
    });
});

SpecEnd