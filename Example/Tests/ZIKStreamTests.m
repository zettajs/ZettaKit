#import "ZIKStream.h"
#import "ZIKLink.h"
#import "ZIKStreamEntry.h"
#import "ZIKMultiplexStreamEntry.h"

SpecBegin(ZIKStream)

NSDictionary *data = @{
                       @"title": @"stream",
                       @"rel": @[@"http://rels.zettajs.io/monitor"],
                       @"href": @"ws://foo.com/events"
                       };
ZIKLink *link = [ZIKLink initWithDictionary:data];

describe(@"ZIKStream", ^{
    describe(@"Initializers", ^{
        it(@"can initialize with the primary initializer", ^{
            ZIKStream *stream = [ZIKStream initWithLink:link];
            expect(stream.title).to.equal(@"stream");
        });
    });
    
    describe(@"stream messages", ^(){
        it(@"Will publish a stream entry when a websocket message is received", ^{
            ZIKStream *stream = [ZIKStream initWithLink:link];
            NSString *data = @"{\"topic\":\"foo/foo/1\", \"timestamp\":0, \"data\":\"1\"}";
            waitUntil(^(DoneCallback done) {
                [stream.signal subscribeNext:^(ZIKStreamEntry *x) {
                    expect(x.topic).to.equal(@"foo/foo/1");
                    done();
                }];
                [stream webSocket:nil didReceiveMessage:data];
            });
        });
        
        it(@"Will publish a different type of message for multiplex websocket streams", ^{
            ZIKStream *stream = [[ZIKStream alloc] initWithLink:link andIsMultiplex:YES];
            NSString *data = @"{\"type\":\"data\", \"topic\":\"foo/foo/foo/1\", \"subscriptionId\":\"1\", \"timestamp\":0, \"data\":\"1\"}";
            waitUntil(^(DoneCallback done) {
                [stream.signal subscribeNext:^(ZIKMultiplexStreamEntry *x) {
                    expect(x.topic).to.equal(@"foo/foo/foo/1");
                    expect(x.subscriptionId).to.equal(@"1");
                    done();
                }];
                [stream webSocket:nil didReceiveMessage:data];
            });
        });
        
        it(@"Will publish an error entry for a protocol error", ^{
            ZIKStream *stream = [[ZIKStream alloc] initWithLink:link andIsMultiplex:YES];
            NSString *data = @"{\"type\":\"error\", \"topic\":\"foo/foo/foo/1\", \"subscriptionId\":\"1\", \"timestamp\":0, \"message\":\"foo\", \"code\":404}";
            waitUntil(^(DoneCallback done) {
                [stream.signal subscribeNext:^(ZIKMultiplexStreamEntry *x) {
                    expect(x.topic).to.equal(@"foo/foo/foo/1");
                    expect(x.message).to.equal(@"foo");
                    expect(x.code).to.equal(404);
                    done();
                }];
                [stream webSocket:nil didReceiveMessage:data];
            });
        });
        
        it(@"Will publish an error for a protocol error", ^{
            ZIKStream *stream = [[ZIKStream alloc] initWithLink:link andIsMultiplex:YES];
            NSString *data = @"{\"type\":\"error\", \"topic\":\"foo/foo/foo/1\", \"subscriptionId\":\"1\", \"timestamp\":0, \"message\":\"foo\", \"code\":404}";
            waitUntil(^(DoneCallback done) {
                [stream.signal subscribeError:^(NSError *error) {
                    expect(error.userInfo[@"message"]).to.equal(@"foo");
                    expect(error.code).to.equal(404);
                    done();
                }];
                [stream webSocket:nil didReceiveMessage:data];
            });
        });
    });
});

SpecEnd