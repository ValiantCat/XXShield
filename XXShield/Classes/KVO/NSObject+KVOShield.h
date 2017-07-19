//
//  NSObject+Shield.h
//  XXShield
//
//  Created by nero on 2017/2/7.
//  Copyright © 2017年 XXShield. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

@interface NSObject (KVOShield)

// Maybe a better way
@end

NS_ASSUME_NONNULL_END

#define KVOADDIgnoreMarco()  \
autoreleasepool {} \
if (object_getClass(observer) == objc_getClass("RACKVOProxy") ) { \
    XXHookOrgin(observer, keyPath, options, context); \
    return; \
}


#define KVORemoveIgnoreMarco()  \
autoreleasepool {} \
if (object_getClass(observer) == objc_getClass("RACKVOProxy") ) {  \
    XXHookOrgin(observer, keyPath);\
    return;  \
}
