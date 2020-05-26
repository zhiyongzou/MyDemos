//
//  MyView1.m
//  iOSDebugDemo
//
//  Created by zzyong on 2020/5/23.
//  Copyright © 2020 zzyong. All rights reserved.
//

#import "MyView1.h"

@implementation MyView1

- (void)sayHello
{
    NSLog(@"%s", __func__);
}

- (void)removeFromSuperview
{
    [super removeFromSuperview];
}

@end
