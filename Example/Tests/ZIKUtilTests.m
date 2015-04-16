
#import "ZIKUtil.h"

SpecBegin(ZIKUtil)

describe(@"ZIKUtil", ^{
    it(@"Will properly encode things.", ^{
        NSDictionary *data = @{@"foo": @"bar", @"test": @2};
        NSString *encodedData = [ZIKUtil urlFormEncodeDictionary:data];
        expect(encodedData).to.equal(@"foo=bar&test=2");
    });
});

SpecEnd
