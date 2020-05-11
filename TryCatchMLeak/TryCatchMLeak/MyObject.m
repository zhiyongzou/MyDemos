//
//  MyObject.m
//  TryCatchMLeak
//
//  Created by zzyong on 2020/5/11.
//  Copyright © 2020 zzyong. All rights reserved.
//

#import "MyObject.h"

@implementation MyObject

- (void)dealloc
{
    NSLog(@"%s", __func__);
}

@end
