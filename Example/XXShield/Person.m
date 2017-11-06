//
//  Person.m
//  XXShield
//
//  Created by nero on 2017/2/7.
//  Copyright © 2017年 XXShield. All rights reserved.
//

#import "Person.h"

@implementation Person

- (void)fireTimer:(NSTimer *)timer {
    NSLog(@"userinfo is %@",timer.userInfo);
}

- (void)fireTimer {
    NSLog(@"fire");
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {

}

- (void)dealloc {
    NSLog(@"person dealloced");
}

- (void)sayHello {
    NSLog(@"person say hello");
}

@end
