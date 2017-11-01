//
//  XXTimerViewController.m
//  XXShield
//
//  Created by nero on 2017/6/23.
//  Copyright © 2017年 XXShield. All rights reserved.
//

#import "XXTimerViewController.h"
#import "Person.h"
#import "Student.h"
#import <XXShield/XXShield.h>

@interface XXTimerViewController ()
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) Person   *timerPerson;
@end

@implementation XXTimerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [XXShieldSDK registerStabilityWithAbility:(EXXShieldTypeTimer)];
    });
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self testTimer];
}
- (void)testTimer {
    // 1 正常使用
//    self.timerPerson = [Person new];
//    [NSTimer scheduledTimerWithTimeInterval:1 target:self.timerPerson selector:@selector(fireTimer) userInfo:@{@"hah":@"jaj"} repeats:YES];
    // 2 target会被runloop持有 造成隐式的内存泄漏 开启防护之后会自动注销timer
    [NSTimer scheduledTimerWithTimeInterval:1 target:[Person new] selector:@selector(fireTimer) userInfo:@{@"hah":@"jaj"} repeats:YES];
    
}

@end
