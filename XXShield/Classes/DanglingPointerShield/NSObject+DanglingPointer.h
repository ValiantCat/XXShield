//
//  NSObject+DanglingPointer.h
//  XXShield
//
//  Created by nero on 2017/1/18.
//  Copyright © 2017年 XXShield. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (DanglingPointer)

- (void)xx_danglingPointer_dealloc;

@end
