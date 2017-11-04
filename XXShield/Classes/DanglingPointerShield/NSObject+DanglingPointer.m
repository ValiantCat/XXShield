//
//  NSObject+DanglingPointer.h
//  XXShield
//
//  Created by nero on 2017/1/18.
//  Copyright © 2017年 XXShield. All rights reserved.
//


#import <objc/runtime.h>
#import "NSObject+DanglingPointer.h"
#import "XXDanglingPointStub.h"
#import "XXDanglingPonterService.h"

static NSInteger const mostCount = 100;

@implementation NSObject (DanglingPointer)

- (void)xx_danglingPointer_dealloc {
    BOOL ifClass = NO;
    for (NSString *className in [XXDanglingPonterService getInstance].classArr) {
        Class clazz = objc_getClass([className UTF8String]);
        if ([self isMemberOfClass:clazz]) {
            ifClass = YES;
        }
        [clazz release];
    }
    
    if (ifClass) {
        objc_destructInstance(self);
        object_setClass(self, [XXDanglingPointStub class]);
        NSMutableArray *temArr = [XXDanglingPonterService getInstance].unDellocClassArr;
        if ([temArr count] >= mostCount) {
            id object = temArr[0];
            [temArr removeObjectAtIndex:0];
            object_dispose(object);
        }
        [temArr addObject:self];
    } else {
        [self xx_danglingPointer_dealloc];
    }
}

@end
