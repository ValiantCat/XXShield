//
//  SDKSetup.m
//  XXShield_Tests
//
//  Created by nero on 2017/11/1.
//  Copyright © 2017年 ValiantCat. All rights reserved.
//

#import <XXShield/XXShieldSDK.h>
#import "XXTestObject.h"

@interface SDKSetup : NSObject <XXRecordProtocol>

@end

@implementation SDKSetup

+ (void)load {
    [XXShieldSDK registerRecordHandler:[self new]];
    [XXShieldSDK registerStabilityWithAbility:(EXXShieldTypeDangLingPointer) withClassNames:@[NSStringFromClass([XXTestObject class])]];
    [XXShieldSDK registerStabilitySDK];
}

- (void)recordWithReason:(NSError *)reason userInfo:(NSDictionary *)userInfo {
    NSLog(@"----------------------------------------------------------------------------------------------------");
    NSLog(@"crashLytics catch fatalError - error is %@, additional UserInfo is %@", reason, userInfo);
}

@end
