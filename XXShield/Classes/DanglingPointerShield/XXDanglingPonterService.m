//
//  XXDanglingPonterClassService.m
//  XXShield
//
//  Created by nero on 2017/1/18.
//  Copyright © 2017年 XXShield. All rights reserved.
//

#import "XXDanglingPonterService.h"
#import <objc/runtime.h>

@implementation XXDanglingPonterService

+ (instancetype)getInstance {
    static XXDanglingPonterService *service = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service = [[XXDanglingPonterService alloc] init];
    });
    return service;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _classArr = @[];
    }
    return self;
}

@end
