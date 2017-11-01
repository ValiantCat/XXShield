//
//  NullSpec.m
//  XXShield_Tests
//
//  Created by nero on 2017/11/1.
//  Copyright © 2017年 aiqiuqiu. All rights reserved.
//

QuickSpecBegin(NullSpec)

describe(@"NullSpec test", ^{
    it(@"should avoid crash by send message to 'NSString' class", ^{
        NSString *null = (NSString *)[NSNull null];
        NSString *result = [null stringByAppendingString:@"fafa"];
        expect(result).to(equal(@"fafa"));
    });
    
    it(@"should avoid crash by send message to 'NSNumber' class", ^{
        NSNumber *null = (NSNumber *)[NSNull null];
        BOOL result = [null boolValue];
        expect(result).to(beFalsy());
    });
    
    it(@"should avoid crash by send message to 'NSArray' class", ^{
        NSArray<NSString *> *null = (NSArray *)[NSNull null];
        NSArray *result = [null arrayByAddingObjectsFromArray:@[@"xx"]];
        expect(result).to(equal(@[@"xx"]));
    });
    
    it(@"should avoid crash by send message to 'NSDictionary' class", ^{
        NSDictionary<NSString *, NSString *> *null = (NSDictionary *)[NSNull null];
        NSArray *allKeys = [null allKeys];
        NSArray *allValues = [null allValues];
        expect(allKeys).to(equal(@[]));
        expect(allValues).to(equal(@[]));
    });
});

QuickSpecEnd
