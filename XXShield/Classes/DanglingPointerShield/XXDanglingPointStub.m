//
//  ForwordingCenterForDanglingPoint.m
//  XXShield
//
//  Created by nero on 2017/1/18.
//  Copyright © 2017年 XXShield. All rights reserved.
//

#import "XXDanglingPointStub.h"
#import <objc/runtime.h>
#import "XXShieldStubObject.h"
#import "XXRecord.h"

@implementation XXDanglingPointStub

- (instancetype)init {
    return self;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    XXShieldStubObject *stub = [XXShieldStubObject shareInstance];
    [stub addFunc:aSelector];

    return [[XXShieldStubObject class] instanceMethodSignatureForSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    NSString *reason = [NSString stringWithFormat:@"target is %@ method is %@, reason : DangLingPointer .",
                        [self class], NSStringFromSelector(_cmd)];
    
    [XXRecord recordFatalWithReason:reason errorType:(EXXShieldTypeDangLingPointer)];
    [anInvocation invokeWithTarget:[XXShieldStubObject shareInstance]];
}

@end

