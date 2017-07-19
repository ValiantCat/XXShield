//
//  XXTestsContainer.m
//  XXShield
//
//  Created by nero on 2017/7/19.
//  Copyright © 2017年 XXShield. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XXShieldSDK.h"

@interface XXTestsContainer : XCTestCase

@end

@implementation XXTestsContainer


- (void)setUp {
    [super setUp];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [XXShieldSDK registerStabilityWithAbility:(EXXShieldTypeContainer| EXXShieldTypeUnrecognizedSelector)];
    });
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


- (void)testNSCache {
    NSCache *cache = [[NSCache alloc] init];
    [cache setObject:@"xx" forKey:@"key"]; //
    NSLog(@"请查看控制台输出");
    [cache setObject:nil forKey:nil];
}
- (void)testMutableDictionary {
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    NSLog(@"请查看控制台输出");
    [mDic setObject:nil forKey:nil];
    mDic = @{}.mutableCopy;
    [mDic setObject:nil forKey:nil];
}
- (void)testMutableNSArray {
    NSMutableArray *mA = @[].mutableCopy;
    NSLog(@"请查看控制台输出");
    
    
    
    [mA addObject:@"1"];
    XCTAssertEqual(@"1", mA[1]);
    
    
    [mA insertObject:@"2" atIndex:1];
    XCTAssertEqual(@"2", mA[1]);
    [mA replaceObjectAtIndex:1 withObject:@"3"];
    XCTAssertEqual(@"3", mA[1]);
    [mA removeObjectAtIndex:1];
    XCTAssertEqual(1, mA.count);
    
    mA= @[].mutableCopy;
    int  x = [mA[10] integerValue];
    XCTAssertEqual( x + 1 ,1);
}

- (void)testxDictionary {
    
    const id  os[] = { @"1", nil};
    const id  ks[] = { @"1", @"2"};
    NSLog(@"请查看控制台输出");
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:os forKeys:ks count:2];
    
}
- (void)testArray {
    const id  os[] = { @"1",nil};
    NSLog(@"请查看控制台输出");
    NSArray *arr = [NSArray arrayWithObjects:os count:2];
    NSLog(@"请查看控制台输出");
    arr = @[]; //__NSArray0,
    arr[10];
    NSLog(@"请查看控制台输出");
    arr = @[@1];  //__NSSingleObjectArrayI,
    arr[10];
    NSLog(@"请查看控制台输出");
    arr = @[@1,@2];//__NSArrayI,
    arr[10];
    
    
    
}



@end
