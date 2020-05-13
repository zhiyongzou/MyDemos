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

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupSubviews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self doSomething];
}

- (void)setupSubviews
{
    
}

- (void)doSomething
{
    
}

@end
