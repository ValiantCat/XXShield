//
//  NSMutableDictionary+Shield.m
//  XXShield
//
//  Created by nero on 2017/1/19.
//  Copyright © 2017年 XXShield. All rights reserved.
//

#import "NSMutableDictionary+Shield.h"
#import "XXRecord.h"
#import "XXShieldSwizzling.h"

@implementation NSMutableDictionary (Shield)


XXStaticHookPrivateClass(__NSDictionaryM, NSMutableDictionary*, ProtectCont, void,@selector(setObject:forKey:), (id)anObject, (id<NSCopying>)aKey ) {
    if (anObject && aKey) {
        XXHookOrgin(anObject,aKey);
    } else {
        NSString *reason = [NSString stringWithFormat:@"target is %@ method is %@, reason : ket or value appear nil- key is %@, obj is %@",
                            [self class], XXSEL2Str(@selector(setObject:forKey:)),aKey, anObject];
        
        [XXRecord recordFatalWithReason:reason userinfo:nil errorType:EXXShieldTypeContainer];
    }
    
}
XXStaticHookEnd



@end
