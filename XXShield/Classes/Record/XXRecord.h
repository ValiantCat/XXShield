//
//  XXRecord.h
//  XXShield
//
//  Created by nero on 2017/1/18.
//  Copyright © 2017年 XXShield. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XXShield/XXShieldSDK.h>

@interface XXRecord : NSObject

/**
 汇报Crash

 @param reason Sting 原因， maybe nil
 @param userInfo 额外的信息 maybe nil
 */
+ (void)recordFatalWithReason:(nullable NSString *)reason
                     userinfo:(nullable NSDictionary<NSString *, id> *)userInfo
                    errorType:(EXXShieldType)type;

/**
 汇报Crash
 
 @param error Sting 原因， maybe nil
 @param userInfo 额外的信息 maybe nil
 */
+ (void)recordFatalWithError:(nonnull NSError *)error
                    userinfo:(nullable NSDictionary<NSString *, id> *)userInfo;


@end
