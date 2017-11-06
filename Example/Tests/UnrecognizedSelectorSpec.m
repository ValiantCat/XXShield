//
//  UnrecognizedSelectorSpec.m
//  XXShield_Tests
//
//  Created by nero on 2017/11/1.
//  Copyright © 2017年 ValiantCat. All rights reserved.
//

#import "Student.h"

@interface NSObject (XX_Private)

- (int)doesnotExistMethodWithArg1:(NSObject *)obj arg2:(int)xx;

@end;

QuickSpecBegin(UnrecognizedSelectorSpec)

describe(@"UnrecognizedSelector test", ^{
    it(@"should raise an exception when send message to an doesn't exist method while the class from system.", ^{
        expectAction(^{
            NSObject *object = NSObject.new;
            [object doesnotExistMethodWithArg1:nil arg2:100];
        }).to(raiseException().named(@"NSInvalidArgumentException"));
    });
    it(@"should avoid crash when send message to an doesn't exist method while the class from system.", ^{
        Student *object = Student.new;
        int result = [object doesnotExistMethodWithArg1:nil arg2:100];
        expect(result).to(equal(0));
    });
});

QuickSpecEnd
