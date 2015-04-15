//
//  ZettaKitTests.m
//  ZettaKitTests
//
//  Created by Matthew Dobson on 04/14/2015.
//  Copyright (c) 2014 Matthew Dobson. All rights reserved.
//

SpecBegin(InitialSpecs)

describe(@"these will pass", ^{
    
    it(@"can do maths", ^{
        expect(1).beLessThan(23);
    });

});

SpecEnd
