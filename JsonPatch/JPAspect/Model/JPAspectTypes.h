//
//  JPAspectTypes.h
//  JPAspect
//
//  Created by zzyong on 2019/11/5.
//  Copyright © 2019 zzyong. All rights reserved.
//

#ifndef JPAspectTypes_h
#define JPAspectTypes_h

#import <Foundation/Foundation.h>

#ifdef DEBUG
    #define JPAspectLog(fmt, ...) do { NSLog((@"%s %d: " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__); }while(0)
#else
    #define JPAspectLog(...)
#endif

typedef NS_ENUM(NSUInteger, JPArgumentType) {
    
    JPArgumentTypeUnknown           = 0,
    JPArgumentTypeObject            = 1, // id
    JPArgumentTypeClass             = 2,
    JPArgumentTypeBool              = 3,
    JPArgumentTypeLong              = 4, // NSInteger
    JPArgumentTypeUnsignedLong      = 5, // NSUInteger
    JPArgumentTypeShort             = 6,
    JPArgumentTypeUnsignedShort     = 7,
    JPArgumentTypeLongLong          = 8,
    JPArgumentTypeUnsignedLongLong  = 9,
    JPArgumentTypeFloat             = 10,
    JPArgumentTypeDouble            = 11, // CGFolat
    JPArgumentTypeInt               = 12,
    JPArgumentTypeUnsignedInt       = 13,
    JPArgumentTypeSEL               = 14,
    JPArgumentTypeCGSize            = 15,
    JPArgumentTypeCGPoint           = 16,
    JPArgumentTypeCGRect            = 17,
    JPArgumentTypeUIEdgeInsets      = 18
};

typedef NS_ENUM(NSUInteger, JPAspectHookType) {
    
    JPAspectHookUnknown              = 0, // Unknown
    JPAspectHookNullImp              = 1, // Instead with empty IMP
    JPAspectHookCustomInvokeBefore   = 2, // Custom function invoke before original
    JPAspectHookCustomInvokeAfter    = 3, // Custom function invoke after original
    JPAspectHookCustomInvokeInstead  = 4  // Custom function invoke instead original
};

typedef NS_ENUM(NSUInteger, JPAspectMessageType) {
    
    JPAspectMessageTypeFunction      = 0, // 方法调用
    JPAspectMessageTypeReturn        = 1, // 返回语句
    JPAspectMessageTypeAssign        = 2  // 赋值语句
};

#endif /* JPAspectTypes_h */
