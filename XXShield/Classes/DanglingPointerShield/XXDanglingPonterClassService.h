//
//  XXDanglingPonterClassService.h
//  XXShield
//
//  Created by nero on 2017/1/18.
//  Copyright © 2017年 XXShield. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XXDanglingPonterClassService : NSObject

@property (nonatomic, copy) NSArray<NSString *> *classArr;

@property (nonatomic, strong) NSMutableArray *unDellocClassArr;

+ (instancetype)getInstance;

@end
