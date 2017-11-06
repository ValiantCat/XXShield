//
//  XXRecord.h
//  XXShield
//
//  Created by nero on 2017/1/18.
//  Copyright © 2017年 XXShield. All rights reserved.
//

#import <XXShield/XXShieldSDK.h>

@interface XXRecord : NSObject

/**
 注册汇报中心

 @param record 汇报中心
 */
+ (void)registerRecordHandler:(nullable id<XXRecordProtocol>)record;

/**
 汇报Crash

 @param reason Sting 原因， maybe nil
 */
+ (void)recordFatalWithReason:(nullable NSString *)reason
                    errorType:(EXXShieldType)type;

@end
