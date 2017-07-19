//
//  NSArray+Shield.m
//  XXShield
//
//  Created by nero on 2017/1/19.
//  Copyright © 2017年 XXShield. All rights reserved.
//

#import <objc/runtime.h>
#import "NSArray+Shield.h"
#import "XXRecord.h"
#import <UIKit/UIKit.h>
#import "XXShieldSwizzling.h"

@implementation NSArray (Shield)
//NSArray<NSString *> *arrayClasses = @[@"__NSSingleObjectArrayI",@"__NSArrayI",@"__NSArray0"];

/**
 hook @selector(objectAtIndex:)

 @param 
 @param NSArray
 @param ProtectCont
 @param id
 @param objectAtIndex:
 @return safe
 */

XXStaticHookPrivateClass(__NSSingleObjectArrayI, NSArray *, ProtectCont, id, @selector(objectAtIndex:),(NSUInteger)index) {
    #include "NSArrayObjectAtIndex.x"
}
XXStaticHookEnd
XXStaticHookPrivateClass(__NSArrayI, NSArray *, ProtectCont, id, @selector(objectAtIndex:),(NSUInteger)index) {
    #include "NSArrayObjectAtIndex.x"
}
XXStaticHookEnd
XXStaticHookPrivateClass(__NSArray0, NSArray *, ProtectCont, id, @selector(objectAtIndex:),(NSUInteger)index) {
    #include "NSArrayObjectAtIndex.x"
}
XXStaticHookEnd


//NSArray<NSString *> *arrayClasses = @[@"__NSSingleObjectArrayI",@"__NSArrayI",@"__NSArray0"];

/**
 hook @selector(arrayWithObjects:count:),
 
 @param
 @param NSArray
 @param ProtectCont
 @param id
 @param objectAtIndex:
 @return safe
 */

    

XXStaticHookPrivateMetaClass(__NSSingleObjectArrayI, NSArray *, ProtectCont, NSArray *,
                             @selector(arrayWithObjects:count:), (const id *)objects, (NSUInteger)cnt) {
    #include "NSArrayWithObjects.x"
}
XXStaticHookEnd

XXStaticHookPrivateMetaClass(__NSArrayI, NSArray *, ProtectCont, NSArray *, @selector(arrayWithObjects:count:),
                             (const id *)objects, (NSUInteger)cnt) {
    #include "NSArrayWithObjects.x"
}
XXStaticHookEnd

XXStaticHookPrivateMetaClass(__NSArray0, NSArray *, ProtectCont, NSArray *, @selector(arrayWithObjects:count:),
                             (const id *)objects, (NSUInteger)cnt) {
    #include "NSArrayWithObjects.x"
}
XXStaticHookEnd

XXStaticHookPrivateClass(__NSPlaceholderArray, NSArray *, ProtectCont, NSArray *, @selector(initWithObjects:count:),
                             (const id *)objects, (NSUInteger)cnt) {
    #include "NSArrayWithObjects.x"
}
XXStaticHookEnd

@end



