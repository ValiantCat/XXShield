//
//  NSNull+Shield.m
//  XXShield
//
//  Created by nero on 2017/1/19.
//  Copyright © 2017年 XXShield. All rights reserved.
//

#import "XXShieldSwizzling.h"

XXStaticHookClass(NSNull, ProtectNull, id, @selector(forwardingTargetForSelector:), (SEL) aSelector) {
    static NSArray *sTmpOutput = nil;
    if (sTmpOutput == nil) {
        sTmpOutput = @[@"", @0, @[], @{}];
    }
    
    for (id tmpObj in sTmpOutput) {
        if ([tmpObj respondsToSelector:aSelector]) {
            return tmpObj;
        }
    }
    return XXHookOrgin(aSelector);
}
XXStaticHookEnd

