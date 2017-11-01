//
//  XXRecord.m
//  XXShield
//
//  Created by nero on 2017/1/18.
//  Copyright © 2017年 XXShield. All rights reserved.
//

#import "XXRecord.h"

@implementation XXRecord

static id<XXRecordProtocol> __record;

+ (void)registerRecordHandler:(id<XXRecordProtocol>)record {
    __record = record;
}

+ (void)recordFatalWithReason:(nullable NSString *)reason
                     userinfo:(nullable NSDictionary<NSString *, id> *)userInfo
                    errorType:(EXXShieldType)type {
    
    NSDictionary<NSString *, id> *errorInfo = @{ NSLocalizedDescriptionKey : (reason.length ? reason : @"未标识原因" )};
    NSError *error = [NSError errorWithDomain:@"com.xxshield" code:-type userInfo:errorInfo];
    [__record recordWithReason:error userInfo:userInfo];
}

@end
