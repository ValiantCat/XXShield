//
//  UnrecognizedSelectorSpec.m
//  XXShield_Tests
//
//  Created by nero on 2017/11/1.
//  Copyright © 2017年 aiqiuqiu. All rights reserved.
//


@interface NSObject (XX_Private)

- (int)doesnotExistMethodWithArg1:(NSObject *)obj arg2:(int)xx;

@end;

QuickSpecBegin(UnrecognizedSelectorSpec)

describe(@"UnrecognizedSelector test", ^{
    it(@"should avoid crash by send message to an doesn't exist method.", ^{
        NSObject *object = NSObject.new;
        int result = [object doesnotExistMethodWithArg1:nil arg2:100];
        expect(result).to(equal(0));
    });
});

QuickSpecEnd
