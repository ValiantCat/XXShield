//
//  NSObject+Forward.m
//  XXShield
//
//  Created by nero on 2017/1/19.
//  Copyright © 2017年 XXShield. All rights reserved.
//
#import <objc/runtime.h>
#import <dlfcn.h>
#import "XXShieldStubObject.h"
#import "XXRecord.h"
#import "XXShieldSwizzling.h"

static bool startsWith(const char *pre, const char *str) {
    size_t lenpre = strlen(pre),
    lenstr = strlen(str);
    return lenstr < lenpre ? false : strncmp(pre, str, lenpre) == 0;
}


XXStaticHookClass(NSObject, ProtectFW, id, @selector(forwardingTargetForSelector:), (SEL)aSelector) {
    static dispatch_once_t onceToken;
    static char *app_bundle_path = NULL;
    
    dispatch_once(&onceToken, ^{
        const char *path = [[[NSBundle mainBundle] bundlePath] UTF8String];
        app_bundle_path = malloc(strlen(path) + 1);
        strcpy(app_bundle_path, path);
    });
    
    struct dl_info self_info = {0};
    dladdr((__bridge void *)[self class], &self_info);
    
    //    ignore system class
    if (self_info.dli_fname == NULL || !startsWith(app_bundle_path, self_info.dli_fname)) {
        return XXHookOrgin(aSelector);
    }
    
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
        [XXRecord recordFatalWithReason:reason errorType:EXXShieldTypeUnrecognizedSelector];
        
        return stub;
    }
}
XXStaticHookEnd

XXStaticHookMetaClass(NSObject, ProtectFW, id, @selector(forwardingTargetForSelector:), (SEL)aSelector) {
    BOOL aBool = [self respondsToSelector:aSelector];
    
    NSMethodSignature *signatrue = [self methodSignatureForSelector:aSelector];
    
    if (aBool || signatrue) {
        return XXHookOrgin(aSelector);
    } else {
        [XXShieldStubObject addClassFunc:aSelector];
        NSString *reason = [NSString stringWithFormat:@"*****Warning***** logic error.target is %@ method is %@, reason : method forword to SmartFunction Object default implement like send message to nil.",
                            [self class], NSStringFromSelector(aSelector) ];
        [XXRecord recordFatalWithReason:reason errorType:EXXShieldTypeUnrecognizedSelector];
        
        return [XXShieldStubObject class];
    }
}
XXStaticHookEnd

