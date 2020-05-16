//
//  MyClassA.m
//  RuntimeTestDemo
//
//  Created by zzyong on 2019/12/3.
//  Copyright © 2019 zzyong. All rights reserved.
//

#import "MyClassA.h"

@implementation MyClassA

- (instancetype)init
{
    if (self = [super init]) {
        self.name = self.className;
    }
    return self;
}

+ (void)sayHelloWorld
{
    NSLog(@"MyClassA Hello World !");
}

@end
