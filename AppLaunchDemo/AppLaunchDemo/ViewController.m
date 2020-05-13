//
//  ViewController.m
//  AppLaunchDemo
//
//  Created by zzyong on 2020/5/8.
//  Copyright © 2020 zzyong. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

void(^block1)(void) = ^(void){
    
};

void test()
{
    block1();
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self sayHello];
    test();
}

- (void)sayHello
{
    
}

@end
