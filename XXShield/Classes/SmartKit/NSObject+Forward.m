//
//  NSObject+Forward.m
//  XXShield
//
//  Created by nero on 2017/1/19.
//  Copyright © 2017年 XXShield. All rights reserved.
//
#import <objc/runtime.h>
#import "XXShieldStubObject.h"
#import "XXRecord.h"
#import "XXShieldSwizzling.h"

XXStaticHookClass(NSObject, ProtectFW, id, @selector(forwardingTargetForSelector:), (SEL)aSelector) {
    // 1 如果是NSSNumber 和NSString没找到就是类型不对  切换下类型就好了
    if ([self isKindOfClass:[NSNumber class]] && [NSString instancesRespondToSelector:aSelector]) {
        NSNumber *number = (NSNumber *)self;
        NSString *str = [number stringValue];
        return str;
    } else if ([self isKindOfClass:[NSString class]] && [NSNumber instancesRespondToSelector:aSelector]) {
        NSString *str = (NSString *)self;
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        NSNumber *number = [formatter numberFromString:str];
        return number;
    }
    
    BOOL aBool = [self respondsToSelector:aSelector];
    NSMethodSignature *signatrue = [self methodSignatureForSelector:aSelector];
    
    if (aBool || signatrue) {
        return XXHookOrgin(aSelector);
    } else {
        XXShieldStubObject *stub = [XXShieldStubObject shareInstance];
        [stub addFunc:aSelector];
        
        NSString *reason = [NSString stringWithFormat:@"*****Warning***** logic error.target is %@ method is %@, reason : method forword to SmartFunction Object default implement like send message to nil.",
                            [self class], NSStringFromSelector(aSelector)];
        [XXRecord recordFatalWithReason:reason userinfo:nil errorType:EXXShieldTypeUnrecognizedSelector];
        
        return stub;
    }
}
XXStaticHookEnd

XXStaticHookMetaClass(NSObject, ProtectFW, id, @selector(forwardingTargetForSelector:), (SEL)aSelector) {
    BOOL aBool = [self respondsToSelector:aSelector];
    // 获取消息签名
    NSMethodSignature *signatrue = [self methodSignatureForSelector:aSelector];
    
    if (aBool || signatrue) {
        return XXHookOrgin(aSelector);
    } else {
        [XXShieldStubObject addClassFunc:aSelector];
        NSString *reason = [NSString stringWithFormat:@"*****Warning***** logic error.target is %@ method is %@, reason : method forword to SmartFunction Object default implement like send message to nil.",
                            [self class], NSStringFromSelector(aSelector) ];
        [XXRecord recordFatalWithReason:reason userinfo:nil errorType:EXXShieldTypeUnrecognizedSelector];
        
        return [XXShieldStubObject class];
    }
}
XXStaticHookEnd

