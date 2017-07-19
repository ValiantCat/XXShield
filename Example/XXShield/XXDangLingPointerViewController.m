//
//  XXViewController.m
//  XXShield
//
//  Created by aiqiuqiu on 04/19/2017.
//  Copyright (c) 2017 XXShield. All rights reserved.
//

#import "XXDangLingPointerViewController.h"
#import "XXDangLingObject.h"
#import "XXShieldSDK.h"

@interface XXDangLingPointerViewController ()

@end

@implementation XXDangLingPointerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [XXShieldSDK registerStabilityWithAbility:EXXShieldTypeDangLingPointer withClassNames:@[@"XXDangLingObject",@"UIViewController"]];
    });
	
}

#pragma mark - DanglingPointer
- (void)testDanglingPointer {
    // only log  don't crash
    for (int i = 0; i < 1; i ++) {
        XXDangLingObject *o = [[XXDangLingObject alloc] init];
        [o release];
        [o performSelector:@selector(test)];
        
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self testDanglingPointer];
}
@end
