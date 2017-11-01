//
//  XXShieldSwizzling.h
//  XXShield
//
//  Created by nero on 2017/1/19.
//  Copyright © 2017年 XXShield. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "XXMetamacros.h"

#define XXForOCString(_) @#_

#define XXSEL2Str(_) NSStringFromSelector(_)

#define FOREACH_ARGS(MACRO, ...)  \
        metamacro_if_eq(1,metamacro_argcount(__VA_ARGS__))                                                      \
        ()                                                                                                      \
        (metamacro_foreach(MACRO , , metamacro_tail(__VA_ARGS__)))                                              \


#define CREATE_ARGS_DELETE_PAREN(VALUE) ,VALUE

#define CREATE_ARGS(INDEX,VALUE) CREATE_ARGS_DELETE_PAREN VALUE

#define __CREATE_ARGS_DELETE_PAREN(...) \
        [type appendFormat:@"%s",@encode(metamacro_head(__VA_ARGS__))];

#define CRATE_TYPE_CODING_DEL_VAR(TYPE) TYPE ,

#define CRATE_TYPE_CODING(INDEX,VALUE) \
        __CREATE_ARGS_DELETE_PAREN(CRATE_TYPE_CODING_DEL_VAR VALUE)

#define __XXHookType__void ,

#define __XXHookTypeIsVoidType(...)  \
        metamacro_if_eq(metamacro_argcount(__VA_ARGS__),2)

#define XXHookTypeIsVoidType(TYPE) \
        __XXHookTypeIsVoidType(__XXHookType__ ## TYPE)

// 调用原始函数 
#define XXHookOrgin(...)                                                                                        \
            __xx_hook_orgin_function                                                                            \
            ?__xx_hook_orgin_function(self,__xxHookSel,##__VA_ARGS__)                                           \
            :((typeof(__xx_hook_orgin_function))(class_getMethodImplementation(__xxHookSuperClass,__xxHookSel)))(self,__xxHookSel,##__VA_ARGS__)


// 生成真实调用函数
#define __XXHookClassBegin(theHookClass,                                                                        \
                           notWorkSubClass,                                                                     \
                           addMethod,                                                                           \
                           returnValue,                                                                         \
                           returnType,                                                                          \
                           theSEL,                                                                              \
                           theSelfTypeAndVar,                                                                   \
                           ...)                                                                                 \
                                                                                                                \
    static char associatedKey;                                                                                  \
    __unused Class __xxHookClass = shield_hook_getClassFromObject(theHookClass);                                \
    __unused Class __xxHookSuperClass = class_getSuperclass(__xxHookClass);                                     \
    __unused SEL __xxHookSel  = theSEL;                                                                         \
    if (nil == __xxHookClass                                                                                    \
        || objc_getAssociatedObject(__xxHookClass, &associatedKey))                                             \
    {                                                                                                           \
        return NO;                                                                                              \
    }                                                                                                           \
    metamacro_if_eq(addMethod,1)                                                                                \
    (                                                                                                           \
        if (!class_respondsToSelector(__xxHookClass,__xxHookSel))                                               \
        {                                                                                                       \
            id _emptyBlock = ^returnType(id self                                                                \
                                         FOREACH_ARGS(CREATE_ARGS,1,##__VA_ARGS__ ))                            \
            {                                                                                                   \
                Method method = class_getInstanceMethod(__xxHookSuperClass,__xxHookSel);                        \
                if (method)                                                                                     \
                {                                                                                               \
                    __unused                                                                                    \
                    returnType(*superFunction)(theSelfTypeAndVar,                                               \
                                               SEL _cmd                                                         \
                                               FOREACH_ARGS(CREATE_ARGS,1,##__VA_ARGS__ ))                      \
                    = (void*)method_getImplementation(method);                                                  \
                    XXHookTypeIsVoidType(returnType)                                                            \
                    ()                                                                                          \
                    (return )                                                                                   \
                    superFunction(self,__xxHookSel,##__VA_ARGS__);                                              \
                }                                                                                               \
                else                                                                                            \
                {                                                                                               \
                    XXHookTypeIsVoidType(returnType)                                                            \
                    (return;)                                                                                   \
                    (return returnValue;)                                                                       \
                }                                                                                               \
            };                                                                                                  \
            NSMutableString *type = [[NSMutableString alloc] init];                                             \
            [type appendFormat:@"%s@:", @encode(returnType)];                                                   \
            FOREACH_ARGS(CRATE_TYPE_CODING,1,##__VA_ARGS__ )                                                    \
            class_addMethod(__xxHookClass,                                                                      \
                            theSEL,                                                                             \
                            (IMP)imp_implementationWithBlock(_emptyBlock),                                      \
                            type.UTF8String);                                                                   \
        }                                                                                                       \
    )                                                                                                           \
    ()                                                                                                          \
    if (!class_respondsToSelector(__xxHookClass,__xxHookSel))                                                   \
    {                                                                                                           \
        return NO;                                                                                              \
    }                                                                                                           \
    __block __unused                                                                                            \
    returnType(*__xx_hook_orgin_function)(theSelfTypeAndVar,                                                    \
                                          SEL _cmd                                                              \
                                          FOREACH_ARGS(CREATE_ARGS,1,##__VA_ARGS__ ))                           \
                = NULL;                                                                                         \
    id newImpBlock =                                                                                            \
    ^returnType(theSelfTypeAndVar FOREACH_ARGS(CREATE_ARGS,1,##__VA_ARGS__ )) {                                 \
            metamacro_if_eq(notWorkSubClass,1)                                                                  \
            (if (!shield_hook_check_block(object_getClass(self),__xxHookClass,&associatedKey))                  \
             {                                                                                                  \
              XXHookTypeIsVoidType(returnType)                                                                  \
              (XXHookOrgin(__VA_ARGS__ ); return;)                                                              \
              (return XXHookOrgin(__VA_ARGS__ );)                                                               \
            })                                                                                                  \
            ()                                                                                                  \


#define __xxHookClassEnd                                                                                        \
    };                                                                                                          \
    objc_setAssociatedObject(__xxHookClass,                                                                     \
                             &associatedKey,                                                                    \
                             [newImpBlock copy],                                                                \
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);                                                \
    __xx_hook_orgin_function = shield_hook_imp_function(__xxHookClass,                                          \
                                                         __xxHookSel,                                           \
                                                         imp_implementationWithBlock(newImpBlock));             \
                                                                                                                \

// 拦截静态类 私有
#define __XXStaticHookClass(theCFunctionName,theHookClassType,selfType,GroupName,returnType,theSEL,... )        \
        static BOOL theCFunctionName ();                                                                        \
        static void* metamacro_concat(theCFunctionName, pointer) __attribute__ ((used, section ("__DATA,__sh" # GroupName))) = theCFunctionName;                                   \
        static BOOL theCFunctionName () {                                                                       \
        __XXHookClassBegin(theHookClassType,                                                                    \
                           0,                                                                                   \
                           0,                                                                                   \
                            ,                                                                                   \
                            returnType,                                                                         \
                            theSEL,                                                                             \
                            selfType self,                                                                      \
                            ##__VA_ARGS__)                                                                      \

// 拦截静态类
#define XXStaticHookPrivateClass(theHookClassType,publicType,GroupName,returnType,theSEL,... )                  \
        __XXStaticHookClass(metamacro_concat(__shield_hook_auto_load_function_ , __COUNTER__),                  \
                            NSClassFromString(@#theHookClassType),                                              \
                            publicType,                                                                         \
                            GroupName,                                                                          \
                            returnType,                                                                         \
                            theSEL,                                                                             \
                            ## __VA_ARGS__ )                                                                    \

#define XXStaticHookClass(theHookClassType,GroupName,returnType,theSEL,... )                                    \
        __XXStaticHookClass(metamacro_concat(__shield_hook_auto_load_function_ , __COUNTER__),                  \
                            [theHookClassType class],                                                           \
                            theHookClassType*,                                                                  \
                            GroupName,                                                                          \
                            returnType,                                                                         \
                            theSEL,                                                                             \
                            ## __VA_ARGS__ )                                                                    \

// 拦截静态类
#define XXStaticHookMetaClass(theHookClassType,GroupName,returnType,theSEL,... )                                \
        __XXStaticHookClass(metamacro_concat(__shield_hook_auto_load_function_ , __COUNTER__),                  \
                            object_getClass([theHookClassType class]),                                          \
                            Class,                                                                              \
                            GroupName,                                                                          \
                            returnType,                                                                         \
                            theSEL,                                                                             \
                            ## __VA_ARGS__ )                                                                    \

// 拦截静态类
#define XXStaticHookPrivateMetaClass(theHookClassType,publicType,GroupName,returnType,theSEL,... )              \
        __XXStaticHookClass(metamacro_concat(__shield_hook_auto_load_function_ , __COUNTER__),                  \
                            object_getClass(NSClassFromString(@#theHookClassType)),                             \
                            publicType,                                                                         \
                            GroupName,                                                                          \
                            returnType,                                                                         \
                            theSEL,                                                                             \
                            ## __VA_ARGS__ )                                                                    \

#define XXStaticHookEnd   __xxHookClassEnd        return YES;                                                   \
                    }

#define XXStaticHookEnd_SaveOri(P) __xxHookClassEnd P = __xx_hook_orgin_function;  return YES;   }              \



#define NSSelectorFromWordsForEach(INDEX,VALUE)                                                                 \
            metamacro_if_eq(metamacro_is_even(INDEX),1)                                                         \
                                (@#VALUE)                                                                       \
                                (@"%@")

#define NSSelectorFromWordsForEach2(INDEX,VALUE)                                                                \
            metamacro_if_eq(metamacro_is_even(INDEX),1)                                                         \
                                ()                                                                              \
                                (,@#VALUE)

#define NSSelectorFromWords(...) \
        NSSelectorFromString( [NSString stringWithFormat:metamacro_foreach(NSSelectorFromWordsForEach,,__VA_ARGS__) \
        metamacro_foreach(NSSelectorFromWordsForEach2,,__VA_ARGS__) ])





// 私有 请不要手动调用
void * shield_hook_imp_function(Class clazz,
                                SEL   sel,
                                void  *newFunction);
BOOL shield_hook_check_block(Class objectClass, Class hookClass,void* associatedKey);
Class shield_hook_getClassFromObject(id object);


// 启动
void shield_hook_load_group(NSString* groupName);
BOOL defaultSwizzlingOCMethod(Class self, SEL origSel_, SEL altSel_);
