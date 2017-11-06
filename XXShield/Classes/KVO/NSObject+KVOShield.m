//
//  NSObject+KVOShield.m
//  XXShield
//
//  Created by nero on 2017/2/7.
//  Copyright © 2017年 XXShield. All rights reserved.
//

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

#import "XXShieldSwizzling.h"
#import <objc/runtime.h>
#import "XXRecord.h"

static void(*__xx_hook_orgin_function_removeObserver)(NSObject* self, SEL _cmd ,NSObject *observer ,NSString *keyPath) = ((void*)0);

@interface XXKVOProxy : NSObject {
    __unsafe_unretained NSObject *_observed;
}

/**
 {keypath : [ob1,ob2](NSHashTable)}
 */
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSHashTable<NSObject *> *> *kvoInfoMap;

@end

@implementation XXKVOProxy

- (instancetype)initWithObserverd:(NSObject *)observed {
    if (self = [super init]) {
        _observed = observed;
    }
    return self;
}

- (void)dealloc {
    @autoreleasepool {
        NSDictionary<NSString *, NSHashTable<NSObject *> *> *kvoinfos =  self.kvoInfoMap.copy;
        for (NSString *keyPath in kvoinfos) {
            // call original  IMP
            __xx_hook_orgin_function_removeObserver(_observed,@selector(removeObserver:forKeyPath:),self, keyPath);
        }
    }
}

- (NSMutableDictionary<NSString *,NSHashTable<NSObject *> *> *)kvoInfoMap {
    if (!_kvoInfoMap) {
        _kvoInfoMap = @{}.mutableCopy;
    }
    return  _kvoInfoMap;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    // dispatch to origina observers
    NSHashTable<NSObject *> *os = self.kvoInfoMap[keyPath];
    for (NSObject  *observer in os) {
        @try {
            [observer observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        } @catch (NSException *exception) {
            NSString *reason = [NSString stringWithFormat:@"non fatal Error%@",[exception description]];
            [XXRecord recordFatalWithReason:reason errorType:(EXXShieldTypeKVO)];
        }
    }
}

@end

#pragma mark - KVOStabilityProperty

@interface NSObject (KVOShieldProperty)

@property (nonatomic, strong) XXKVOProxy *kvoProxy;

@end

@implementation NSObject (KVOShield)

- (void)setKvoProxy:(XXKVOProxy *)kvoProxy {
    objc_setAssociatedObject(self, @selector(kvoProxy), kvoProxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (XXKVOProxy *)kvoProxy {
    return objc_getAssociatedObject(self, @selector(kvoProxy));
}

@end

#pragma mark - hook KVO

XXStaticHookClass(NSObject, ProtectKVO, void, @selector(addObserver:forKeyPath:options:context:),
                  (NSObject *)observer, (NSString *)keyPath,(NSKeyValueObservingOptions)options, (void *)context) {
    @KVOADDIgnoreMarco()
    
    if (!self.kvoProxy) {
        @autoreleasepool {
            self.kvoProxy = [[XXKVOProxy alloc] initWithObserverd:self];
        }
    }
    
    NSHashTable<NSObject *> *os = self.kvoProxy.kvoInfoMap[keyPath];
    if (os.count == 0) {
        os = [[NSHashTable alloc] initWithOptions:(NSPointerFunctionsWeakMemory) capacity:0];
        [os addObject:observer];
        
        XXHookOrgin(self.kvoProxy, keyPath, options, context);
        self.kvoProxy.kvoInfoMap[keyPath] = os;
        return ;
    }
    
    if ([os containsObject:observer]) {
        NSString *reason = [NSString stringWithFormat:@"target is %@ method is %@, reason : KVO add Observer to many timers.",
                            [self class], XXSEL2Str(@selector(addObserver:forKeyPath:options:context:))];
        
        [XXRecord recordFatalWithReason:reason errorType:(EXXShieldTypeKVO)];
    } else {
        [os addObject:observer];
    }
}
XXStaticHookEnd

XXStaticHookClass(NSObject, ProtectKVO, void, @selector(removeObserver:forKeyPath:),
                  (NSObject *)observer, (NSString *)keyPath) {
    @KVORemoveIgnoreMarco()
    NSHashTable<NSObject *> *os = self.kvoProxy.kvoInfoMap[keyPath];
    
    if (os.count == 0) {
        NSString *reason = [NSString stringWithFormat:@"target is %@ method is %@, reason : KVO remove Observer to many times.",
                            [self class], XXSEL2Str(@selector(removeObserver:forKeyPath:))];
        [XXRecord recordFatalWithReason:reason errorType:(EXXShieldTypeKVO)];
        return;
    }
    
    [os removeObject:observer];
    
    if (os.count == 0) {
        XXHookOrgin(self.kvoProxy, keyPath);
        [self.kvoProxy.kvoInfoMap removeObjectForKey:keyPath];
    }
}
XXStaticHookEnd_SaveOri(__xx_hook_orgin_function_removeObserver)
