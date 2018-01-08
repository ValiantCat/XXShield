//
//  NSMutableArray+Shield.m
//  XXShield
//
//  Created by nero on 2017/1/19.
//  Copyright © 2017年 XXShield. All rights reserved.
//

#import "XXRecord.h"
#import "XXShieldSwizzling.h"

XXStaticHookPrivateClass(__NSArrayM, NSMutableArray *, ProtectCont, id, @selector(objectAtIndexedSubscript:), (NSUInteger)index) {
    if (index >= self.count) {
        NSString *reason = [NSString stringWithFormat:@"target is %@ method is %@,reason : index %@ out of count %@ of marray ",
                            [self class], XXSEL2Str(@selector(objectAtIndex:)),@(index), @(self.count)];
        [XXRecord recordFatalWithReason:reason errorType:(EXXShieldTypeContainer)];
        return nil;
    }
    
    return XXHookOrgin(index);
}
XXStaticHookEnd

XXStaticHookPrivateClass(__NSArrayM, NSMutableArray *, ProtectCont, void, @selector(addObject:), (id)anObject ) {
    if (anObject) {
        XXHookOrgin(anObject);
    }
}
XXStaticHookEnd

XXStaticHookPrivateClass(__NSArrayM, NSMutableArray *, ProtectCont, void, @selector(insertObject:atIndex:), (id)anObject, (NSUInteger)index) {
    if (anObject) {
        XXHookOrgin(anObject, index);
    }
}
XXStaticHookEnd

XXStaticHookPrivateClass(__NSArrayM,NSMutableArray *, ProtectCont, void, @selector(removeObjectAtIndex:), (NSUInteger)index) {
    if (index >= self.count) {
        NSString *reason = [NSString stringWithFormat:@"target is %@ method is %@,reason : index %@ out of count %@ of marray ",
                            [self class], XXSEL2Str(@selector(removeObjectAtIndex:)) ,@(index), @(self.count)];
        
        [XXRecord recordFatalWithReason:reason errorType:(EXXShieldTypeContainer)];
    } else {
        XXHookOrgin(index);
    }
}
XXStaticHookEnd

XXStaticHookPrivateClass(__NSArrayM, NSMutableArray *, ProtectCont, void, @selector(setObject:atIndexedSubscript:), (id) obj, (NSUInteger) idx) {
    if (obj) {
        if (idx > self.count) {
            NSString *reason = [NSString stringWithFormat:@"target is %@ method is %@,reason : index %@ out of count %@ of marray ",
                                [self class], XXSEL2Str(@selector(setObject:atIndexedSubscript:)) ,@(idx), @(self.count)];
            [XXRecord recordFatalWithReason:reason errorType:(EXXShieldTypeContainer)];
        } else {
            XXHookOrgin(obj, idx);
        }
    } else {
        NSString *reason = [NSString stringWithFormat:@"target is %@ method is %@, reason : object appear nil obj is %@",
                            [self class], XXSEL2Str(@selector(setObject:atIndexedSubscript:)), obj];
        [XXRecord recordFatalWithReason:reason errorType:(EXXShieldTypeContainer)];
    }
}
XXStaticHookEnd

