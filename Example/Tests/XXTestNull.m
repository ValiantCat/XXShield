//
//  XXTestNull.m
//  XXShield
//
//  Created by nero on 2017/7/19.
//  Copyright © 2017年 XXShield. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XXShieldSDK.h"

@interface XXTestNull : XCTestCase

@end

@implementation XXTestNull

- (void)setUp {
    [super setUp];
    [XXShieldSDK registerStabilityWithAbility:(EXXShieldTypeNSNull)];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testNSNull {
    
    id nsn = [NSNull null];
    id l =  [nsn stringByAppendingString:@"fafa"];// [nsn touchesForView:nil]; crash
    XCTAssertEqual(l, @"fafa");
}



@end
