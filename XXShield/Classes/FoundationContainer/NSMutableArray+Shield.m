//
//  NSMutableArray+Shield.m
//  XXShield
//
//  Created by nero on 2017/1/19.
//  Copyright © 2017年 XXShield. All rights reserved.
//

#import "NSMutableArray+Shield.h"
#import "XXRecord.h"
#import "XXShieldSwizzling.h"

@implementation NSMutableArray (Shield)
//
XXStaticHookPrivateClass(__NSArrayM,NSMutableArray *,ProtectCont, id, @selector(objectAtIndex:), (NSUInteger)index) {
    if (self.count == 0) {
        NSString *reason = [NSString stringWithFormat:@"target is %@ method is %@,reason : index %@ out of count %@ of marray ",
                            [self class], XXSEL2Str(@selector(objectAtIndex:)),@(index), @(self.count)];
        [XXRecord recordFatalWithReason:reason userinfo:nil errorType:(EXXShieldTypeContainer)];
        [self addObject:[NSObject new]];
        /// depend s NSObject+XXShield.m;
    }
    
    if (index > self.count - 1) {
        index = self.count - 1;
        NSString *reason = [NSString stringWithFormat:@"target is %@ method is %@,reason : index %@ out of count %@ of marray ",
                            [self class], XXSEL2Str(@selector(objectAtIndex:)),@(index), @(self.count)];
        [XXRecord recordFatalWithReason:reason userinfo:nil errorType:(EXXShieldTypeContainer)];
    }
    
    return XXHookOrgin(index);
}
XXStaticHookEnd
XXStaticHookPrivateClass(__NSArrayM,NSMutableArray * , ProtectCont, void, @selector(addObject:), (id)anObject ) {
    if (anObject) {
        XXHookOrgin(anObject);
    }
}
XXStaticHookEnd
XXStaticHookPrivateClass(__NSArrayM,NSMutableArray *, ProtectCont, void, @selector(insertObject:atIndex:), (id)anObject, (NSUInteger)index) {
    if (anObject) {
        XXHookOrgin(anObject,index);
    }
}
XXStaticHookEnd

XXStaticHookPrivateClass(__NSArrayM,NSMutableArray *, ProtectCont, void, @selector(removeObjectAtIndex:),  (NSUInteger)index) {
    if (self.count == 0) {
        return;
    }
    
    if (index > self.count - 1) {
        NSString *reason = [NSString stringWithFormat:@"target is %@ method is %@,reason : index %@ out of count %@ of marray ",
                            [self class], XXSEL2Str(@selector(removeObjectAtIndex:)) ,@(index), @(self.count)];
        
        [XXRecord recordFatalWithReason:reason userinfo:nil errorType:(EXXShieldTypeContainer)];
        index = self.count - 1;
    }
    
    XXHookOrgin(index);
}
XXStaticHookEnd

XXStaticHookPrivateClass(__NSArrayM,NSMutableArray *, ProtectCont, void, @selector(replaceCharactersInRange:withString:),  (NSUInteger)index, (id)anObject) {
    if (index > self.count - 1) {
        NSString *reason = [NSString stringWithFormat:@"target is %@ method is %@,reason : index %@ out of count %@ of marray ",
                            [self class], XXSEL2Str(@selector(replaceCharactersInRange:withString:)) ,@(index), @(self.count)];
        [XXRecord recordFatalWithReason:reason userinfo:nil errorType:(EXXShieldTypeContainer)];
        
        return;
    }
    
    if (anObject == nil) {
        return;
    }
    XXHookOrgin(index,anObject);
}
XXStaticHookEnd

@end
