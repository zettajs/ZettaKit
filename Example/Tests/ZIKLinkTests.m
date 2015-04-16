#import "ZIKLink.h"


SpecBegin(ZIKLink)

NSDictionary *data = @{
                       @"title": @"67d6368a-7360-4b61-9d97-403f9f43f092",
                       @"rel": @[ @"up", @"http://rels.zettajs.io/server"],
                       @"href": @"http://zt-1-mdobs.herokuapp.com/servers/67d6368a-7360-4b61-9d97-403f9f43f092"
                       };

describe(@"ZIKLink", ^{
    describe(@"initialization", ^{
        it(@"Primary initialization works", ^{
            ZIKLink *link = [ZIKLink initWithDictionary:data];
            expect(link.title).to.equal(@"67d6368a-7360-4b61-9d97-403f9f43f092");
            expect(link.href).to.equal(@"http://zt-1-mdobs.herokuapp.com/servers/67d6368a-7360-4b61-9d97-403f9f43f092");
            expect(link.rel).to.beAKindOf([NSArray class]);
            expect(link.rel).to.haveACountOf(2);
            expect(link.rel[0]).to.equal(@"up");
            expect(link.rel[1]).to.equal(@"http://rels.zettajs.io/server");
        });
           
        it(@"Secondary initialization works", ^{
            ZIKLink *link = [[ZIKLink alloc] initWithDictionary:data];
            expect(link.title).to.equal(@"67d6368a-7360-4b61-9d97-403f9f43f092");
            expect(link.href).to.equal(@"http://zt-1-mdobs.herokuapp.com/servers/67d6368a-7360-4b61-9d97-403f9f43f092");
            expect(link.rel).to.beAKindOf([NSArray class]);
            expect(link.rel).to.haveACountOf(2);
            expect(link.rel[0]).to.equal(@"up");
            expect(link.rel[1]).to.equal(@"http://rels.zettajs.io/server");
        });
    });
    
    describe(@"link searching", ^{
        it(@"can locate a rel properly", ^{
            ZIKLink *link = [ZIKLink initWithDictionary:data];
            BOOL up = [link hasRel:@"up"];
            BOOL server = [link hasRel:@"http://rels.zettajs.io/server"];
            expect(up).to.equal(YES);
            expect(server).to.equal(YES);
        });
        
        it(@"will indicate when a rel not present", ^{
            ZIKLink *link = [ZIKLink initWithDictionary:data];
            BOOL up = [link hasRel:@"down"];
            expect(up).to.equal(NO);
        });
        
        it(@"will properly indicate a non self link", ^{
            ZIKLink *link = [ZIKLink initWithDictionary:data];
            BOOL isSelf = [link isSelf];
            expect(isSelf).to.equal(NO);
        });
        
        it(@"will properly indicate a self link", ^{
            NSDictionary *data = @{
                                   @"title": @"67d6368a-7360-4b61-9d97-403f9f43f092",
                                   @"rel": @[ @"self" ],
                                   @"href": @"http://zt-1-mdobs.herokuapp.com/servers/67d6368a-7360-4b61-9d97-403f9f43f092"
                                   };
            ZIKLink *link = [ZIKLink initWithDictionary:data];
            BOOL isSelf = [link isSelf];
            expect(isSelf).to.equal(YES);
        });
    });
});

SpecEnd