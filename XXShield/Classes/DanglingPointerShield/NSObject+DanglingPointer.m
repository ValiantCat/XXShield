//
//  NSObject+DanglingPointer.h
//  XXShield
//
//  Created by nero on 2017/1/18.
//  Copyright © 2017年 XXShield. All rights reserved.
//


#import "NSObject+DanglingPointer.h"
#import <objc/runtime.h>
#import "ForwordingCenterForDanglingPoint.h"
#import "XXDanglingPonterClassService.h"

static NSInteger const mostCount = 10;

@implementation NSObject (DanglingPointer)

- (void)ljdanglingPointer_dealloc {
    
    BOOL ifClass = NO;
    for (NSString *temClassName in [XXDanglingPonterClassService getInstance].classArr) {
        Class temClass = objc_getClass([temClassName UTF8String]);
        if ([self isMemberOfClass:temClass]) {
            ifClass = YES;
        }
        [temClass release];
    }
    if (ifClass) {
        
        objc_destructInstance(self);
        object_setClass(self, [ForwordingCenterForDanglingPoint class]);
        
        NSMutableArray *temArr = [XXDanglingPonterClassService getInstance].unDellocClassArr;
        if ([temArr count] >= mostCount) {
            id object = temArr[0];
            [temArr removeObjectAtIndex:0];
            object_dispose(object);
        }
        [temArr addObject:self];
    } else {
        [self ljdanglingPointer_dealloc];
    }
}

@end
