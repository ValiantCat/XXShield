//
//  NSMutableDictionary+Shield.m
//  XXShield
//
//  Created by nero on 2017/1/19.
//  Copyright © 2017年 XXShield. All rights reserved.
//

#import "XXRecord.h"
#import "XXShieldSwizzling.h"

XXStaticHookPrivateClass(__NSDictionaryM, NSMutableDictionary *, ProtectCont, void, @selector(setObject:forKey:), (id)anObject, (id<NSCopying>)aKey ) {
    if (anObject && aKey) {
        XXHookOrgin(anObject,aKey);
    } else {
        NSString *reason = [NSString stringWithFormat:@"target is %@ method is %@, reason : key or value appear nil- key is %@, obj is %@",
                            [self class], XXSEL2Str(@selector(setObject:forKey:)),aKey, anObject];
        
        [XXRecord recordFatalWithReason:reason errorType:EXXShieldTypeContainer];
    }
    
}
XXStaticHookEnd

XXStaticHookPrivateClass(__NSDictionaryM, NSMutableDictionary *, ProtectCont, void, @selector(setObject:forKeyedSubscript:), (id)anObject, (id<NSCopying>)aKey ) {
    if (anObject && aKey) {
        XXHookOrgin(anObject,aKey);
    } else {
        NSString *reason = [NSString stringWithFormat:@"target is %@ method is %@, reason : key or value appear nil- key is %@, obj is %@",
                            [self class], XXSEL2Str(@selector(setObject:forKeyedSubscript:)),aKey, anObject];
        
        [XXRecord recordFatalWithReason:reason errorType:EXXShieldTypeContainer];
    }
}
XXStaticHookEnd

XXStaticHookPrivateClass(__NSDictionaryM, NSMutableDictionary *, ProtectCont, void, @selector(removeObjectForKey:), (id<NSCopying>)aKey ) {
    if (aKey) {
        XXHookOrgin(aKey);
    } else {
        NSString *reason = [NSString stringWithFormat:@"target is %@ method is %@, reason : key appear nil- key is %@.",
                            [self class], XXSEL2Str(@selector(setObject:forKey:)),aKey];
        
        [XXRecord recordFatalWithReason:reason errorType:EXXShieldTypeContainer];
    }
    
}
XXStaticHookEnd
