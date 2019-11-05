//
//  JPAspect+CustomInvokeInstead.h
//  JPAspect
//
//  Created by zzyong on 2019/5/9.
//  Copyright © 2019 zzyong. All rights reserved.
//

#import "JPAspect.h"

NS_ASSUME_NONNULL_BEGIN

@interface JPAspect (CustomInvokeInstead)

+ (id)returnObject;
- (id)returnObject;

+ (CGSize)returnSize;
- (CGSize)returnSize;

+ (CGPoint)returnPoint;
- (CGPoint)returnPoint;

+ (CGRect)returnRect;
- (CGRect)returnRect;

+ (UIEdgeInsets)returnEdgeInsets;
- (UIEdgeInsets)returnEdgeInsets;

+ (long)returnLong;
- (long)returnLong;

+ (unsigned long)returnUnsignedLong;
- (unsigned long)returnUnsignedLong;

+ (double)returnDouble;
- (double)returnDouble;

+ (BOOL)returnBool;
- (BOOL)returnBool;

@end

NS_ASSUME_NONNULL_END
