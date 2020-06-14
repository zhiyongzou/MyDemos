//
//  ViewController.m
//  AppMetrics
//
//  Created by zzyong on 2020/5/13.
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

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self performSelector:@selector(viewDidLayoutSubviews) onThread:[NSThread mainThread] withObject:nil waitUntilDone:NO modes:nil];
}

@end
