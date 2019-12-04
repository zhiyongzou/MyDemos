//
//  JPAspect+HookInstead.m
//  JPAspect
//
//  Created by zzyong on 2019/5/9.
//  Copyright © 2019 zzyong. All rights reserved.
//

#import <UIKit/UIGeometry.h>
#import "JPAspect+HookInstead.h"
#import <CoreGraphics/CoreGraphics.h>

@implementation JPAspect (HookInstead)

+ (id)returnObject
{
    return nil;
}

- (id)returnObject
{
    return nil;
}

+ (CGSize)returnSize
{
    return CGSizeZero;
}

- (CGSize)returnSize
{
    return CGSizeZero;
}

+ (CGPoint)returnPoint
{
    return CGPointZero;
}

- (CGPoint)returnPoint
{
    return CGPointZero;
}

+ (CGRect)returnRect
{
    return CGRectZero;
}

- (CGRect)returnRect
{
    return CGRectZero;
}

+ (UIEdgeInsets)returnEdgeInsets
{
    return UIEdgeInsetsZero;
}

- (UIEdgeInsets)returnEdgeInsets
{
    return UIEdgeInsetsZero;
}

+ (long)returnLong
{
    return 0;
}

- (long)returnLong
{
    return 0;
}

+ (unsigned long)returnUnsignedLong
{
    return 0;
}

- (unsigned long)returnUnsignedLong
{
    return 0;
}

+ (double)returnDouble
{
    return 0;
}

- (double)returnDouble
{
    return 0;
}

+ (BOOL)returnBool
{
    return NO;
}

- (BOOL)returnBool
{
    return NO;
}

@end
