//
//  SDKSetup.m
//  XXShield_Tests
//
//  Created by nero on 2017/11/1.
//  Copyright © 2017年 aiqiuqiu. All rights reserved.
//

#import "SDKSetup.h"
#import <XXShield/XXShieldSDK.h>

@implementation SDKSetup

+ (void)load {
    [XXShieldSDK registerStabilitySDK];
}

@end
