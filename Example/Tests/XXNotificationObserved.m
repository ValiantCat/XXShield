//
//  XXNotificationObserved.m
//  XXShield
//
//  Created by nero on 2017/7/19.
//  Copyright © 2017年 XXShield. All rights reserved.
//

#import "XXNotificationObserved.h"
#import "XXNotificationObserver.h"

@implementation XXNotificationObserved


- (instancetype)init {
    self = [super init];
    if (self) {
        XXNotificationObserver *er = [[XXNotificationObserver alloc] init];
        NSLog(@"%@",er);
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"notiName" object:nil];
        });
        NSLog(@"%@",er);
    }
    return self;
}

@end
