//
//  JPTestD.h
//  JsonPatchDemoTests
//
//  Created by zzyong on 2019/12/6.
//  Copyright © 2019 zzyong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JPTestD : NSObject

+ (NSNumber *)returnObject;
- (NSNumber *)returnObject;

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

+ (float)returnFloat;
- (float)returnFloat;

@end

NS_ASSUME_NONNULL_END
