//
//  XXNotificationObserver.m
//  XXShield
//
//  Created by nero on 2017/7/19.
//  Copyright © 2017年 XXShield. All rights reserved.
//

#import "XXNotificationObserver.h"

@implementation XXNotificationObserver

- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(noti:)
                                                     name:@"notiName"
                                                   object:nil];
    }
    return self;
}
- (void)noti:(NSNotification*)noti {
    NSLog(@"hello");
}

- (void)dealloc {
    NSLog(@"dealloc");
}

@end
