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
#import <list>

static NSInteger const threshold = 100;

static std::list<id> undellocedList;

@implementation NSObject (DanglingPointer)

- (void)xx_danglingPointer_dealloc {
    Class selfClazz = object_getClass(self);
    
    BOOL needProtect = NO;
    for (NSString *className in [XXDanglingPonterService getInstance].classArr) {
        Class clazz = objc_getClass([className UTF8String]);
        if (clazz == selfClazz) {
            needProtect = YES;
            break;
        }
    }
    
    if (needProtect) {
        objc_destructInstance(self);
        object_setClass(self, [XXDanglingPointStub class]);
        
        undellocedList.size();
        if (undellocedList.size() >= threshold) {
            id object = undellocedList.front();
            undellocedList.pop_front();
            free(object);
        }
        undellocedList.push_back(self);
    } else {
        [self xx_danglingPointer_dealloc];
    }
}

@end
