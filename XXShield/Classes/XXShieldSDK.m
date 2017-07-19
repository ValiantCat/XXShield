//
//  XXShieldSDK.m
//  XXShield
//
//  Created by nero on 2017/1/18.
//  Copyright © 2017年 XXShield. All rights reserved.
//


#import <objc/runtime.h>
#import <UIKit/UIKit.h>
#import "XXShieldSDK.h"
#import "NSObject+Forward.h"
#import "NSCache+Shield.h"
#import "NSNull+Shield.h"
#import "NSMutableDictionary+Shield.h"
#import "NSMutableArray+Shield.h"
#import "NSDictionary+Shield.h"
#import "NSArray+Shield.h"
#import "NSObject+KVOShield.h"
#import "NSNotificationCenter+Shield.h"
#import "NSTimer+Shield.h"
#import "NSObject+DanglingPointer.h"
#import "XXDanglingPonterClassService.h"
#import "XXShieldSwizzling.h"

#define XXForOCString(_) @#_

@interface XXShieldSDK ()
+ (void)registerUnrecognizedSelector;
+ (void)registerContainer;
+ (void)registerNSNull;
+ (void)registerKVO;
+ (void)registerNotification;
+ (void)registerTimer;


@end

@implementation XXShieldSDK

+ (void)registerStabilitySDK {
    [self registerStabilityWithAbility:(EXXShieldTypeExceptDangLingPointer)];
}
+ (void)registerStabilityWithAbility:(EXXShieldType)ability {
    if (ability & EXXShieldTypeUnrecognizedSelector) {
        [self registerUnrecognizedSelector];
    }
    if (ability & EXXShieldTypeContainer) {
        [self registerContainer];
    }
    if (ability & EXXShieldTypeNSNull) {
        [self registerNSNull];
    }
    if (ability & EXXShieldTypeKVO) {
        [self registerKVO];
    }
    if (ability & EXXShieldTypeNotification) {
        [self registerNotification];
    }
    if (ability & EXXShieldTypeTimer) {
        [self registerTimer];
    }
}
+ (void)registerStabilityWithAbility:(EXXShieldType)ability withClassNames:(NSArray *)arr {
    if ((ability & EXXShieldTypeDangLingPointer) && [arr count]) {
        [self registerDanglingPointer:arr];
    }
    [self registerStabilityWithAbility:ability];
    
  
}


+ (void)registerNSNull {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shield_hook_load_group(XXForOCString(ProtectNull));
    });
}
+ (void)registerContainer {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shield_hook_load_group(XXForOCString(ProtectCont));
    });
    
}
+ (void)registerUnrecognizedSelector {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shield_hook_load_group(XXForOCString(ProtectFW));
    });
}
+ (void)registerKVO {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shield_hook_load_group(XXForOCString(ProtectKVO));
    });
}
+ (void)registerNotification {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        BOOL ABOVE_IOS8  = (([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) ? YES : NO);
        if (!ABOVE_IOS8) {
            shield_hook_load_group(XXForOCString(ProtectNoti));
        }
    });
    
}
+ (void)registerTimer {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shield_hook_load_group(XXForOCString(ProtectTimer));
    });
}

+ (void)registerDanglingPointer:(NSArray *)arr {
    NSMutableArray *avaibleList = arr.mutableCopy;
    for (NSString *className in arr) {
        NSBundle *classBundle = [NSBundle bundleForClass:NSClassFromString(className)];
        if (classBundle != [NSBundle mainBundle]) {
            [avaibleList removeObject:className];
        }
    }
    [XXDanglingPonterClassService getInstance].classArr = avaibleList;
    defaultSwizzlingOCMethod([NSObject class], NSSelectorFromString(@"dealloc"), @selector(ljdanglingPointer_dealloc));
    
}


@end





