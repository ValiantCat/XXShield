//
//  DanglingPointerSpec.m
//  XXShield_Tests
//
//  Created by nero on 2017/11/1.
//  Copyright © 2017年 ValiantCat. All rights reserved.
//

#import "Person.h"

QuickSpecBegin(DanglingPointerSpec)

describe(@"Notification test", ^{
    it(@"should avoid crash by send message to a danglingPointer.", ^{
        __unsafe_unretained Person *obj = nil;
            @autoreleasepool {
                Person *o = [[Person alloc] init];
                obj = o;
                [o release];
            }
        int result = [obj performSelector:@selector(sayHello)];
        expect(result).to(equal(0));
    });
});

QuickSpecEnd

