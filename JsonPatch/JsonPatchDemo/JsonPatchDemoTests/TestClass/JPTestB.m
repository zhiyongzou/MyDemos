//
//  JPTestB.m
//  JsonPatchDemoTests
//
//  Created by zzyong on 2019/12/2.
//  Copyright © 2019 zzyong. All rights reserved.
//

#import "JPTestB.h"

static BOOL jp_isCallClassSuper = NO;

@implementation JPTestB

- (void)selA
{
    
}

- (void)selB
{
    
}

- (void)setIsCallClassSuper:(BOOL)isCallClassSuper
{
    jp_isCallClassSuper = isCallClassSuper;
}

- (BOOL)isCallClassSuper
{
    return jp_isCallClassSuper;
}

- (void)willInitTestObject
{
    self.isCallInstanceSuper = YES;
    NSLog(@"%s", __func__);
}

+ (void)willInitClassTestObject
{
    jp_isCallClassSuper = YES;
    NSLog(@"%s", __func__);
}

- (NSString *)contentWithCustomString:(NSString *)string
{
    return [NSString stringWithFormat:@"jp_%@", string];
}

@end
