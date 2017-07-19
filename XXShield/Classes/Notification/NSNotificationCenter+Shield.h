//
//  NSNotificationCenter+Shield.h
//  XXShield
//
//  Created by nero on 2017/2/8.
//  Copyright © 2017年 XXShield. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface XXObserverRemover : NSObject {
    __strong NSMutableArray *_centers;
    __unsafe_unretained id _obs;
}
@end
