//
//  XXTestNotification.m
//  XXShield
//
//  Created by nero on 2017/7/19.
//  Copyright © 2017年 XXShield. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XXNotificationObserved.h"
#import "XXShieldSDK.h"

@interface XXTestNotification : XCTestCase

@end

@implementation XXTestNotification

- (void)setUp {
    [super setUp];
    [XXShieldSDK registerStabilityWithAbility:(EXXShieldTypeNotification)];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testNotification {
    [XXNotificationObserved new];
}

@end
