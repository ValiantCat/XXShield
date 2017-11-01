//
//  NotificationSpec.m
//  XXShield_Tests
//
//  Created by nero on 2017/11/1.
//  Copyright © 2017年 aiqiuqiu. All rights reserved.
//
#import "XXNotificationObserver.h"

QuickSpecBegin(NotificationSpec)

describe(@"Notification test", ^{
    it(@"should avoid crash by post a notification to an alred dealloced object.", ^{
        @autoreleasepool {
            XXNotificationObserver *_observer = [XXNotificationObserver new];
            [[NSNotificationCenter defaultCenter] addObserver:_observer selector:@selector(noti:) name:@"noti" object:nil];
        }
        waitUntilTimeout(2, ^(void (^done)(void)) {
            dispatch_after(0.5, dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"noti" object:nil];
                 done();
            });
        });
    });
});

QuickSpecEnd

