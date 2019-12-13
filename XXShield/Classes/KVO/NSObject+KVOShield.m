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

#import <pthread/pthread.h>

static void(*__xx_hook_orgin_function_removeObserver)(NSObject* self, SEL _cmd ,NSObject *observer ,NSString *keyPath) = ((void*)0);

@interface XXKVOProxy : NSObject {
    __unsafe_unretained NSObject *_observed;
    pthread_mutex_t _mutex;
}

/**
 {keypath : [ob1,ob2](NSHashTable)}
 */
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSHashTable<NSObject *> *> *kvoInfoMap;

@end

@implementation XXKVOProxy

+ (instancetype)proxyWithObserverd:(NSObject *)observed {
    static dispatch_once_t onceToken;
    static NSMapTable *proxyTable;
    static dispatch_semaphore_t lock;
    
    dispatch_once(&onceToken, ^{
        proxyTable = [NSMapTable weakToWeakObjectsMapTable];
        lock = dispatch_semaphore_create(1);
    });
    XXKVOProxy *proxy = nil;
    dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
    proxy = [proxyTable objectForKey:observed];
    if (proxy == nil) {
        proxy = [[XXKVOProxy alloc] initWithObserverd:observed];
        [proxyTable setObject:proxy forKey:observed];
    }
    dispatch_semaphore_signal(lock);
    return proxy;
}

- (instancetype)initWithObserverd:(NSObject *)observed {
    if (self = [super init]) {
        _observed = observed;
        _kvoInfoMap = [NSMutableDictionary dictionary];

        pthread_mutexattr_t mta;
        pthread_mutexattr_init(&mta);
        pthread_mutexattr_settype(&mta, PTHREAD_MUTEX_RECURSIVE);
        pthread_mutex_init(&_mutex, &mta);
        pthread_mutexattr_destroy(&mta);
    }
    return self;
}

- (void)dealloc {
    @autoreleasepool {
        NSDictionary<NSString *, NSHashTable<NSObject *> *> *kvoinfos =  _kvoInfoMap.copy;
        for (NSString *keyPath in kvoinfos) {
            // call original  IMP
            __xx_hook_orgin_function_removeObserver(_observed,@selector(removeObserver:forKeyPath:),self, keyPath);
        }
    }
    pthread_mutex_destroy(&_mutex);
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    // dispatch to origina observers
    [self lock:^(NSMutableDictionary<NSString *,NSHashTable<NSObject *> *> *kvoInfoMap) {
        NSHashTable<NSObject *> *os = [kvoInfoMap[keyPath] copy];
        for (NSObject  *observer in os) {
            @try {
                [observer observeValueForKeyPath:keyPath ofObject:object change:change context:context];
            } @catch (NSException *exception) {
                NSString *reason = [NSString stringWithFormat:@"non fatal Error%@",[exception description]];
                [XXRecord recordFatalWithReason:reason errorType:(EXXShieldTypeKVO)];
            }
        }
    }];
}

- (void)lock:(void (^)(NSMutableDictionary<NSString *,NSHashTable<NSObject *> *> *kvoInfoMap))blk {
    if (blk) {
        pthread_mutex_lock(&_mutex);
        blk(_kvoInfoMap);
        pthread_mutex_unlock(&_mutex);
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
            self.kvoProxy = [XXKVOProxy proxyWithObserverd:self];
        }
    }
    
    __block BOOL contained = NO;
    [self.kvoProxy lock:^(NSMutableDictionary<NSString *,NSHashTable<NSObject *> *> *kvoInfoMap) {
        BOOL shouldHookOrigin = NO;
        NSHashTable<NSObject *> *os = kvoInfoMap[keyPath];
        if (os.count == 0) {
            os = [[NSHashTable alloc] initWithOptions:(NSPointerFunctionsWeakMemory) capacity:0];
            kvoInfoMap[keyPath] = os;
            shouldHookOrigin = YES;
        }
        if ([os containsObject:observer]) {
            contained = YES;
        }
        else {
            [os addObject:observer];
        }
        if (shouldHookOrigin) {
            // hook origin if needed after kvoInfoMap updated
            XXHookOrgin(self.kvoProxy, keyPath, options, context);
        }
    }];
    if (contained) {
        NSString *reason = [NSString stringWithFormat:@"target is %@ method is %@, reason : KVO add Observer to many timers.",
                            [self class], XXSEL2Str(@selector(addObserver:forKeyPath:options:context:))];
        
        [XXRecord recordFatalWithReason:reason errorType:(EXXShieldTypeKVO)];
    }
}
XXStaticHookEnd

XXStaticHookClass(NSObject, ProtectKVO, void, @selector(removeObserver:forKeyPath:),
                  (NSObject *)observer, (NSString *)keyPath) {
    @KVORemoveIgnoreMarco()
    __block BOOL removed = NO;
    [self.kvoProxy lock:^(NSMutableDictionary<NSString *,NSHashTable<NSObject *> *> *kvoInfoMap) {
        NSHashTable<NSObject *> *os = kvoInfoMap[keyPath];

        if (os.count == 0) {
            removed = YES;
            return;
        }
        
        [os removeObject:observer];
        
        if (os.count == 0) {
            [kvoInfoMap removeObjectForKey:keyPath];
            XXHookOrgin(self.kvoProxy, keyPath);
        }
    }];
    if (removed) {
        NSString *reason = [NSString stringWithFormat:@"target is %@ method is %@, reason : KVO remove Observer to many times.",
                            [self class], XXSEL2Str(@selector(removeObserver:forKeyPath:))];
        [XXRecord recordFatalWithReason:reason errorType:(EXXShieldTypeKVO)];
    }
}
XXStaticHookEnd_SaveOri(__xx_hook_orgin_function_removeObserver)
