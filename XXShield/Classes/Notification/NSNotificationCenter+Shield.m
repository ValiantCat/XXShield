//
//  NSNotificationCenter+Stability.m
//  XXShield
//
//  Created by nero on 2017/2/8.
//  Copyright © 2017年 XXShield. All rights reserved.
//

#import "XXShieldSwizzling.h"

@interface XXObserverRemover : NSObject

@end

@implementation XXObserverRemover {
    __strong NSMutableArray *_centers;
    __unsafe_unretained id _obs;
}

- (instancetype)initWithObserver:(id)obs {
    if (self = [super init]) {
        _obs = obs;
        _centers = @[].mutableCopy;
    }
    return self;
}

- (void)addCenter:(NSNotificationCenter*)center {
    if (center) {
        [_centers addObject:center];
    }
}

- (void)dealloc {
    @autoreleasepool {
        for (NSNotificationCenter *center in _centers) {
            [center removeObserver:_obs];
        }
    }
}

@end

// why autorelasePool
// an instance life dead
// *********************1 release property
// *********************2 remove AssociatedObject
// *********************3 destory self
// Once u want use assobciedObject's dealloc method do something ,
// must in a custome autorelease Pool let associate
// release immediately.
// AssociatedObject retain source target  strategy must be __unsafe_unretain. (weak will be nil )
void addCenterForObserver(NSNotificationCenter *center ,id obs) {
    XXObserverRemover *remover = nil;
    static char removerKey;
    
    @autoreleasepool {
        remover = objc_getAssociatedObject(obs, &removerKey);
        if (!remover) {
            remover = [[XXObserverRemover alloc] initWithObserver:obs];
            objc_setAssociatedObject(obs, &removerKey, remover, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        [remover addCenter:center];
    }
}

XXStaticHookClass(NSNotificationCenter, ProtectNoti,
                  void, @selector(addObserver:selector:name:object:), (id)obs, (SEL)cmd, (NSString*)name, (id)obj) {
    XXHookOrgin(obs, cmd, name, obj);
    addCenterForObserver(self, obs);
}
XXStaticHookEnd
