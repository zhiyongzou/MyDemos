//
//  ViewController.m
//  VisualEffectiOS10Demo
//
//  Created by zzyong on 2020/9/10.
//  Copyright © 2020 zzyong. All rights reserved.
//

#import "ViewController.h"


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addVisualEffectViewWithFrame:CGRectMake(10, 40, 120, 200) alpha:1 mask:nil];
    
    [self addVisualEffectViewWithFrame:CGRectMake(140, 40, 120, 200) alpha:0.9 mask:nil];
    
    // https://developer.apple.com/forums/thread/50854
    // https://github.com/Tawa/TNTutorialManager/issues/16
    // iOS 10，只要 UIVisualEffectView 父试图设置了mask就会失效
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 120, 200) cornerRadius:10];
    CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
    shapeLayer.frame = CGRectMake(0, 0, 120, 200);
    shapeLayer.path = bezierPath.CGPath;
    [self addVisualEffectViewWithFrame:CGRectMake(10, 250, 120, 200) alpha:1 mask:shapeLayer];
}

- (void)addVisualEffectViewWithFrame:(CGRect)frame alpha:(CGFloat)alpha mask:(CALayer *)mask
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1111"]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.frame = frame;
    [self.view addSubview:imageView];
    
    UIView *contentView = [UIView new];
    contentView.frame = frame;
    contentView.alpha = alpha;
    if (mask) {
        [contentView.layer setMask:mask];
    }
    [self.view addSubview:contentView];
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.frame = contentView.bounds;
    [contentView addSubview:blurEffectView];
}

@end
