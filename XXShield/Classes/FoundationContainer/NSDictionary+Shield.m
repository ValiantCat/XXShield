//
//  NSDictionary+Shield.m
//  XXShield
//
//  Created by nero on 2017/1/19.
//  Copyright © 2017年 XXShield. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XXRecord.h"
#import "XXShieldSwizzling.h"

XXStaticHookMetaClass(NSDictionary, ProtectCont, NSDictionary *, @selector(dictionaryWithObjects:forKeys:count:),
                      (const id *) objects, (const id<NSCopying> *) keys, (NSUInteger)cnt) {
    NSUInteger index = 0;
    id  _Nonnull __unsafe_unretained newObjects[cnt];
    id  _Nonnull __unsafe_unretained newkeys[cnt];
    for (int i = 0; i < cnt; i++) {
        id tmpItem = objects[i];
        id tmpKey = keys[i];
        if (tmpItem == nil || tmpKey == nil) {
            NSString *reason = [NSString stringWithFormat:@"target is %@ method is %@, reason : NSDictionary constructor appear nil",
                                [self class], XXSEL2Str(@selector(dictionaryWithObjects:forKeys:count:))];
            [XXRecord recordFatalWithReason:reason errorType:EXXShieldTypeContainer];
            continue;
        }
        newObjects[index] = objects[i];
        newkeys[index] = keys[i];
        index++;
    }
    
    return XXHookOrgin(newObjects, newkeys,index);
}
XXStaticHookEnd

