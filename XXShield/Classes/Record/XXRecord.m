//
//  XXRecord.m
//  XXShield
//
//  Created by nero on 2017/1/18.
//  Copyright © 2017年 XXShield. All rights reserved.
//

#import "XXRecord.h"
//#import <Crashlytics/Crashlytics.h>

@implementation XXRecord

+ (void)recordFatalWithReason:(nullable NSString *)reason
                     userinfo:(nullable NSDictionary<NSString *, id> *)userInfo
                    errorType:(EXXShieldType)type {
    
    NSDictionary<NSString *, id> *errorInfo = @{ NSLocalizedDescriptionKey : (reason.length ? reason : @"未标识原因" )};
    NSError *error = [NSError errorWithDomain:@"com.xxshield" code:-type userInfo:errorInfo];
    [self recordFatalWithError:error userinfo:userInfo];

}

+ (void)recordFatalWithError:(nonnull NSError *)error userinfo:(nullable NSDictionary<NSString *, id> *)userInfo {
    NSLog(@"crashLytics catch fatalError - error is %@, additional UserInfo is %@",error,userInfo);
//    [[Crashlytics sharedInstance] recordError:error withAdditionalUserInfo:userInfo];
}

@end
