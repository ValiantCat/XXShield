//
//  DanglingPointerSpec.m
//  XXShield_Tests
//
//  Created by nero on 2017/11/1.
//  Copyright © 2017年 ValiantCat. All rights reserved.
//

#import "XXTestObject.h"

QuickSpecBegin(DanglingPointerSpec)

describe(@"Notification test", ^{
    it(@"should avoid crash by send message to a danglingPointer.", ^{
        __unsafe_unretained id obj = nil;
            @autoreleasepool {
                XXTestObject *o = [[XXTestObject alloc] init];
                obj = o;
                [o release];
            }
        int result = [obj performSelector:@selector(someDoesnotExistMethod)];
        expect(result).to(equal(0));
    });
});

QuickSpecEnd

