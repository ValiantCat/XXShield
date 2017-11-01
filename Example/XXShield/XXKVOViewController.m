//
//  XXKVOViewController.m
//  XXShield
//
//  Created by nero on 2017/7/19.
//  Copyright © 2017年 XXShield. All rights reserved.
//

#import "XXKVOViewController.h"
#import "Person.h"
#import "Student.h"
#import <XXShield/XXShield.h>

@interface XXKVOViewController ()

@end

@implementation XXKVOViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [XXShieldSDK registerStabilityWithAbility:(EXXShieldTypeKVO)];
    });
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self testKVO1];
    //    [self testKVO2];
    //        [self testKVO3];
}
- (void)testKVO1 {
    //name:
    //    NSInternalInconsistencyException
    //reason:
    //    An instance 0x60800001b5d0 of class Student was deallocated while key value observers were still registered with it. Current observation info: <NSKeyValueObservationInfo 0x608000036ae0> (<NSKeyValueObservance 0x608000051af0: Observer: 0x7fa27d507150, Key path: name, Options: <New: YES, Old: YES, Prior: NO> Context: 0x0, Property: 0x608000051a30>
    // 被观察者提前释放 Crash
    Student *s = [[Student alloc] init];
    s.name = @"zs";
    
    [s addObserver:self
        forKeyPath:@"name"
           options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
           context:nil];
    
    // 延时1000ms后改变stu的name属性值
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //        p.name = @"Jane";
    //    });
}

- (void)testKVO2 {
    [self addObserver:[Person new ] forKeyPath:@"view" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:NULL];
    
    self.view = [UIView new]; // Crash
    // 被观察者是局部变量  触发KVOCrash
}

- (void)testKVO3 {
    
    // for test  重复添加
    //            [self addObserver:self forKeyPath:@"view" options:(NSKeyValueObservingOptionNew) context:NULL];
    [self addObserver:self forKeyPath:@"view" options:(NSKeyValueObservingOptionNew) context:NULL];
    
    
    self.view = [UIView new];
    // 会触发多次响应事件
    
    // for test 多余的移除会导致Crash  because it is not registered as an observer.'
    [self removeObserver:self forKeyPath:@"view"];
    [self removeObserver:self forKeyPath:@"view"];
}

//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
//   NSLog(@"%@",object);
//}

@end
