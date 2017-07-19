//
//  XXShieldDefine.h
//  Pods
//
//  Created by nero on 2017/7/19.
//
//

#ifndef XXShieldDefine_h
#define XXShieldDefine_h


typedef NS_OPTIONS(NSUInteger, EXXShieldType) {
    EXXShieldTypeUnrecognizedSelector = 1 << 1,
    EXXShieldTypeContainer = 1 << 2,
    EXXShieldTypeNSNull = 1 << 3,
    EXXShieldTypeKVO = 1 << 4,
    EXXShieldTypeNotification = 1 << 5,
    EXXShieldTypeTimer = 1 << 6,
    EXXShieldTypeDangLingPointer = 1 << 7,
    EXXShieldTypeExceptDangLingPointer = (EXXShieldTypeUnrecognizedSelector | EXXShieldTypeContainer |
                                          EXXShieldTypeNSNull| EXXShieldTypeKVO |
                                          EXXShieldTypeNotification | EXXShieldTypeTimer)
};

#endif /* XXShieldDefine_h */
