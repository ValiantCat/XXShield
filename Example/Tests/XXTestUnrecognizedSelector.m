//
//  XXTestUnrecognizedSelector.m
//  XXShield
//
//  Created by nero on 2017/7/19.
//  Copyright © 2017年 XXShield. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XXShieldSDK.h"

@interface XXTestUnrecognizedSelector : XCTestCase

@end

@implementation XXTestUnrecognizedSelector

- (void)setUp {
    [super setUp];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [XXShieldSDK registerStabilityWithAbility:(EXXShieldTypeUnrecognizedSelector)];
    });
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


- (void)testClassFunc {
    
    XCTAssertNil( [[NSString class] performSelector:@selector(sharedApplication:)]);
}
- (void)testInstanceFunc {
    XCTAssertNil( [@"" performSelector:@selector(sharedApplication:)]);
}

@end
