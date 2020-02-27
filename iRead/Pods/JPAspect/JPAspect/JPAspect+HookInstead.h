//
//  JPAspect+HookInstead.h
//  JPAspect
//
//  Created by zzyong on 2019/5/9.
//  Copyright © 2019 zzyong. All rights reserved.
//

#import "JPAspect.h"
#import <UIKit/UIGeometry.h>
#import <CoreGraphics/CoreGraphics.h>

NS_ASSUME_NONNULL_BEGIN

@interface JPAspect (HookInstead)

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

+ (NSRange)returnRange;
- (NSRange)returnRange;

+ (long)returnLong;
- (long)returnLong;

+ (int)returnInt;
- (int)returnInt;

+ (unsigned long)returnUnsignedLong;
- (unsigned long)returnUnsignedLong;

+ (double)returnDouble;
- (double)returnDouble;

+ (BOOL)returnBool;
- (BOOL)returnBool;

@end

NS_ASSUME_NONNULL_END
