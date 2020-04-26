//
//  ViewController.m
//  iOSDebugDemo
//
//  Created by zzyong on 2020/4/26.
//  Copyright © 2020 zzyong. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *aLbael;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSLog(@"UILabel layer class: %@", self.aLbael.layer.class);
    
    UIImageView *imgView = [UIImageView new];
    NSLog(@"UIImageView layer class: %@", imgView.layer.class);
    
    UIView *aView = [UIView new];
    NSLog(@"UIView layer class: %@", aView.layer.class);
}

@end
