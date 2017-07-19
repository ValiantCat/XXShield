//
//  NSDictionary+Shield.m
//  XXShield
//
//  Created by nero on 2017/1/19.
//  Copyright © 2017年 XXShield. All rights reserved.
//

#import "NSDictionary+Shield.h"
#import "XXRecord.h"
#import "XXShieldSwizzling.h"

@implementation NSDictionary (Shield)

XXStaticHookMetaClass(NSDictionary, ProtectCont, NSDictionary *, @selector(dictionaryWithObjects:forKeys:count:),
                      (const id *) objects, (const id<NSCopying> *) keys, (NSUInteger)cnt) {
    
    for (int i = 0; i < cnt; i++) {
        id tmpItem = objects[i];
        id tmpKey = keys[i];
        if (tmpItem == nil || tmpKey == nil) {
            NSString *reason = [NSString stringWithFormat:@"target is %@ method is %@, reason : NSDictionary constructor appear nil",
                                [self class], XXSEL2Str(@selector(dictionaryWithObjects:forKeys:count:))];
            [XXRecord recordFatalWithReason:reason userinfo:nil errorType:EXXShieldTypeContainer];
            return nil;
        }
    }
    
    return XXHookOrgin(objects,keys,cnt);
}
XXStaticHookEnd





@end
