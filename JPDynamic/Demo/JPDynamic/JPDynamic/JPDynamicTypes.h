//
//  JPDynamicTypes.h
//  JPDynamic
//
//  Created by zzyong on 2020/3/27.
//  Copyright © 2020 zzyong. All rights reserved.
//

#ifndef JPDynamicTypes_h
#define JPDynamicTypes_h

#import <Foundation/Foundation.h>

#if OBJC_API_VERSION >= 2
    #define JPGetClass(obj)    object_getClass(obj)
#else
    #define JPGetClass(obj)    (obj ? obj->isa : Nil)
#endif

#ifdef DEBUG
    #define JPDynamicLog(fmt, ...) do { NSLog((@"%s %d: " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__); }while(0)
#else
    #define JPDynamicLog(fmt, ...)
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
    JPArgumentTypeUIEdgeInsets      = 18,
    JPArgumentTypeNSRange           = 19
};

typedef NS_ENUM(NSUInteger, JPDynamicHookType) {
    
    JPDynamicHookUnknown              = 0, // Unknown
    JPDynamicHookCustomInvokeBefore   = 1, // Custom function invoke before original
    JPDynamicHookCustomInvokeAfter    = 2, // Custom function invoke after original
    JPDynamicHookCustomInvokeInstead  = 3  // Custom function invoke instead original
};

typedef NS_ENUM(NSUInteger, JPDynamicMessageType) {
    
    JPDynamicMessageTypeFunction      = 0, // 方法调用
    JPDynamicMessageTypeReturn        = 1, // 返回语句
    JPDynamicMessageTypeAssign        = 2  // 赋值语句
};

#endif /* JPDynamicTypes_h */
