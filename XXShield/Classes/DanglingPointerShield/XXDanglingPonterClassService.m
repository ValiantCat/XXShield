//
//  XXDanglingPonterClassService.m
//  XXShield
//
//  Created by nero on 2017/1/18.
//  Copyright © 2017年 XXShield. All rights reserved.
//

#import "XXDanglingPonterClassService.h"
#import <objc/runtime.h>

@implementation XXDanglingPonterClassService

+ (instancetype)getInstance {
    
    static XXDanglingPonterClassService *service = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service = [[XXDanglingPonterClassService alloc] init];
    });
    
    return service;
}

- (instancetype)init {
    
    self = [super init];
    if (self) {
        [self serviceInit];
    }
    
    return self;
}

- (void)serviceInit {
    
    self.classArr = [NSArray array];
    self.unDellocClassArr = [NSMutableArray array];
}

@end
