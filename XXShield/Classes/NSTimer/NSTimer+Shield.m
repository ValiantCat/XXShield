//
//  NSTimer+Shield.m
//  XXShield
//
//  Created by nero on 2017/2/8.
//  Copyright © 2017年 XXShield. All rights reserved.
//

#import <objc/runtime.h>
#import "XXRecord.h"
#import "XXShieldSwizzling.h"

@interface XXTimerProxy : NSObject

@property (nonatomic, weak) NSTimer *sourceTimer;
@property (nonatomic, weak) id target;
@property (nonatomic) SEL aSelector;

@end

@implementation XXTimerProxy

- (void)trigger:(id)userinfo  {
    id strongTarget = self.target;
    if (strongTarget && ([strongTarget respondsToSelector:self.aSelector])) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [strongTarget performSelector:self.aSelector withObject:userinfo];
#pragma clang diagnostic pop
    } else {
        NSTimer *sourceTimer = self.sourceTimer;
        if (sourceTimer) {
            [sourceTimer invalidate];
        }
        NSString *reason = [NSString stringWithFormat:@"*****Warning***** logic error target is %@ method is %@, reason : an object dealloc not invalidate Timer.",[self class], NSStringFromSelector(self.aSelector)];
        
        [XXRecord recordFatalWithReason:reason errorType:(EXXShieldTypeTimer)];
    }
}

@end

XXStaticHookMetaClass(NSTimer, ProtectTimer,  NSTimer * ,@selector(scheduledTimerWithTimeInterval:target:selector:userInfo:repeats:),
                      (NSTimeInterval)ti , (id)aTarget, (SEL)aSelector, (id)userInfo, (BOOL)repeats ) {
    if (repeats) {
        NSTimer *timer =  nil ;
        @autoreleasepool {
            XXTimerProxy *proxy = [XXTimerProxy new];
            proxy.target = aTarget;
            proxy.aSelector = aSelector;
            proxy.sourceTimer = XXHookOrgin(ti, proxy, @selector(trigger:), userInfo, repeats);
        }
        return  timer;
    }
    return XXHookOrgin(ti, aTarget, aSelector, userInfo, repeats);
}
XXStaticHookEnd
