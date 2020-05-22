//
//  MyClassA1.m
//  AppLaunchDemo
//
//  Created by zzyong on 2020/5/20.
//  Copyright © 2020 zzyong. All rights reserved.
//

#import "MyClassA1.h"

@implementation MyClassA1

+ (void)sayHello
{
    // 由于先加载主工程的 MyClassA1 ，所以会忽略 MyFrameworkA.framework 的 MyClassA1
    NSLog(@"Main poject MyClassA1 sayHello");
}

@end
