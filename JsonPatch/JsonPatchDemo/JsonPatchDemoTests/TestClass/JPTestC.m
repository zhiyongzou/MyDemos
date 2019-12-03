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

@end
