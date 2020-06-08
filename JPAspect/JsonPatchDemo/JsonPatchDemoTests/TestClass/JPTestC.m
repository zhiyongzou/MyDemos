//
//  JPTestC.m
//  JsonPatchDemoTests
//
//  Created by zzyong on 2019/12/2.
//  Copyright © 2019 zzyong. All rights reserved.
//

#import "JPTestC.h"

@implementation JPTestC

- (void)sayGoodBye
{
    NSLog(@"%s", __func__);
}

- (void)willInitTestObject
{
    NSLog(@"%s", __func__);
}

+ (void)willInitClassTestObject
{
    NSLog(@"%s", __func__);
}

- (NSString *)contentWithCustomString:(NSString *)string
{
    return nil;
}

- (NSString *)multiArgumentMethod:(NSString *)aString index:(NSUInteger)index flag:(BOOL)flag
{
    return [NSString stringWithFormat:@"%@_%@_%@", aString, @(index), @(flag)];
}

- (NSString *)multiArgumentMethodTest
{
    return nil;
}

- (NSString *)modifyGetter
{
    if (_modifyGetter == nil) {
        _modifyGetter = @"JPTestC";
    }
    
    return _modifyGetter;
}

- (BOOL)modifySelfArgument:(nullable JPTestC *)testC
{
    return [testC isKindOfClass:[JPTestC class]];
}

- (NSString *)modifyArgumentToNil:(nullable NSString *)string
{
    return string;
}

- (NSString *)andOperatorTest
{
//    if ([self andCondition1] && [self andCondition2]) {
//        return @"&&";
//    }
    
    return nil;
}

- (NSString *)orOperatorTest
{
//    if ([self orCondition1] || [self orCondition2]) {
//        return @"||";
//    }
    
    return nil;
}

#pragma mark - Private

- (BOOL)andCondition1
{
    return YES;
}

- (BOOL)andCondition2
{
    return YES;
}

- (BOOL)orCondition1
{
    return NO;
}

- (BOOL)orCondition2
{
    return YES;
}

@end
