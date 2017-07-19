//
//  XXShieldStubObject.m
//  XXShield
//
//  Created by nero on 2017/1/19.
//  Copyright © 2017年 XXShield. All rights reserved.
//

#import "XXShieldStubObject.h"
#import <objc/runtime.h>
/**
 default Implement

 @param target trarget
 @param cmd cmd
 @param ... other param
 @return default Implement is zero
 */
int smartFunction(id target, SEL cmd, ...) {
    return 0;
}

@implementation XXShieldStubObject
- (BOOL)addFunc:(SEL)sel {
    NSString *selName = NSStringFromSelector(sel);
    
    NSMutableString *tmpString = [[NSMutableString alloc] initWithFormat:@"%@", selName];
    
    int count = (int)[tmpString replaceOccurrencesOfString:@":"
                                                withString:@"_"
                                                   options:NSCaseInsensitiveSearch
                                                     range:NSMakeRange(0, selName.length)];
    
    NSMutableString *val = [[NSMutableString alloc] initWithString:@"i@:"];
    
    for (int i = 0; i < count; i++) {
        
        [val appendString:@"@"];
    }
    
    const char *funcTypeEncoding = [val UTF8String];
    
    return class_addMethod([XXShieldStubObject class], sel, (IMP)smartFunction, funcTypeEncoding);
}

+ (BOOL)addClassFunc:(SEL)sel {
    NSString *selName = NSStringFromSelector(sel);
    
    NSMutableString *tmpString = [[NSMutableString alloc] initWithFormat:@"%@", selName];
    
    int count = (int)[tmpString replaceOccurrencesOfString:@":"
                                                withString:@"_"
                                                   options:NSCaseInsensitiveSearch
                                                     range:NSMakeRange(0, selName.length)];
    
    NSMutableString *val = [[NSMutableString alloc] initWithString:@"i@:"];
    
    for (int i = 0; i < count; i++) {
        
        [val appendString:@"@"];
    }
    
    const char *funcTypeEncoding = [val UTF8String];
    
    Class metaClass = objc_getMetaClass(class_getName([XXShieldStubObject class]));
    
    return class_addMethod(metaClass, sel, (IMP)smartFunction, funcTypeEncoding);
}

@end
