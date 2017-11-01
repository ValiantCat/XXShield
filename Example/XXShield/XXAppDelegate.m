//
//  XXAppDelegate.m
//  XXShield
//
//  Created by XXShield on 07/10/2017.
//  Copyright (c) 2017 XXShield. All rights reserved.
//

#import "XXAppDelegate.h"
@import ObjectiveC.runtime;

@implementation XXAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    NSLog(@"%@", [self findAllOf:[NSArray class]]);
    
//    WebCascadeList,
//    CSSearchableItemCodedArray,
//    "_PFEncodedArray",
//    "_PFBatchFaultingArray",
//    "_PFArray",
//    "_NSMetadataQueryResultGroupArray",
//    "_NSMetadataQueryResultArray",
//    "_NSCallStackArray",
//    NSKeyValueArray,
//    "__NSArrayI_Transfer",
//    "__NSArrayReversed",
//    "__NSOrderedSetArrayProxy",
//    "_CTFontFallbacksArray",
//    "_NSConstantArray",
//    CALayerArray,
//    "__NSArrayI",
//    "__NSFrozenArrayM",
//    "__NSArray0",
//    "__NSSingleObjectArrayI",
//    NSMutableArray
    return YES;
}

//- (NSArray *)findAllOf:(Class)defaultClass {
//
//    int count = objc_getClassList(NULL, 0);
//
//    if (count <= 0) {
//
//        @throw@"Couldn't retrieve Obj-C class-list";
//
//        return @[defaultClass];
//    }
//
//    NSMutableArray *output = @[].mutableCopy;
//
//    Class *classes = (Class *) malloc(sizeof(Class) * count);
//
//    objc_getClassList(classes, count);
//
//    for (int i = 0; i < count; ++i) {
//
//        if (defaultClass == class_getSuperclass(classes[i]))//子类
//        {
//            [output addObject:classes[i]];
//        }
//
//    }
//
//    free(classes);
//
//    return output.copy;
//
//}

@end
