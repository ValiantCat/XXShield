//
//  XXShieldSDK.h
//  XXShield
//
//  Created by nero on 2017/1/18.
//  Copyright © 2017年 XXShield. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger, EXXShieldType) {
    EXXShieldTypeUnrecognizedSelector = 1 << 1,
    EXXShieldTypeContainer = 1 << 2,
    EXXShieldTypeNSNull = 1 << 3,
    EXXShieldTypeKVO = 1 << 4,
    EXXShieldTypeNotification = 1 << 5,
    EXXShieldTypeTimer = 1 << 6,
    EXXShieldTypeDangLingPointer = 1 << 7,
    EXXShieldTypeExceptDangLingPointer = (EXXShieldTypeUnrecognizedSelector | EXXShieldTypeContainer |
                                          EXXShieldTypeNSNull| EXXShieldTypeKVO |
                                          EXXShieldTypeNotification | EXXShieldTypeTimer)
};

@protocol XXRecordProtocol <NSObject>

- (void)recordWithReason:(NSError *)reason;

@end

@interface XXShieldSDK : NSObject

/**
 注册汇报中心
 
 @param record 汇报中心
 */
+ (void)registerRecordHandler:(id<XXRecordProtocol>)record;

/**
 注册SDK，默认只要开启就打开防Crash，如果需要DEBUG关闭，请在调用处使用条件编译
 本注册方式不包含EXXShieldTypeDangLingPointer类型
 */
+ (void)registerStabilitySDK;

/**
 本注册方式不包含EXXShieldTypeDangLingPointer类型
 
 @param ability ability
 */
+ (void)registerStabilityWithAbility:(EXXShieldType)ability;

/**
 ///注册EXXShieldTypeDangLingPointer需要传入存储类名的array，不支持系统框架类。
 
 @param ability ability description
 @param classNames 野指针类列表
 */
+ (void)registerStabilityWithAbility:(EXXShieldType)ability withClassNames:(nonnull NSArray<NSString *> *)classNames;

@end

NS_ASSUME_NONNULL_END

