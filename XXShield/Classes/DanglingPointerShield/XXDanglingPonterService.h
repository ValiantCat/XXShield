//
//  XXDanglingPonterClassService.h
//  XXShield
//
//  Created by nero on 2017/1/18.
//  Copyright © 2017年 XXShield. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XXDanglingPonterService : NSObject

@property (nonatomic, copy) NSArray<NSString *> *classArr;

+ (instancetype)getInstance;

@end
