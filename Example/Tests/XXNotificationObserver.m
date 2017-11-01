//
//  XXNotificationObserver.m
//  XXShield
//
//  Created by nero on 2017/7/19.
//  Copyright © 2017年 XXShield. All rights reserved.
//

#import "XXNotificationObserver.h"

@implementation XXNotificationObserver

- (void)noti:(NSNotification*)noti {
    NSLog(@"hello");
}

- (void)dealloc {
    NSLog(@"dealloc");
}

@end
