//
//  JPTestC.m
//  JsonPatchDemoTests
//
//  Created by zzyong on 2019/12/2.
//  Copyright © 2019 zzyong. All rights reserved.
//

#import "JPTestC.h"

@implementation JPTestC

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

@end
