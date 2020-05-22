//
//  ViewController.m
//  AppLaunchDemo
//
//  Created by zzyong on 2020/5/8.
//  Copyright © 2020 zzyong. All rights reserved.
//

#import "ViewController.h"
#import "MyClassA1.h"
#import <MyStaticLibA/MyView.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupSubviews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MyClassA1 sayHello];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self doSomething];
}

- (void)setupSubviews
{
    MyView *view = [[MyView alloc] init];
    view.frame = CGRectMake(100, 100, 100, 100);
    [self.view addSubview:view];
}

- (void)doSomething
{
    
}

@end
