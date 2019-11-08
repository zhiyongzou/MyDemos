//
//  ViewController.m
//  UIButtonDelayDemo
//
//  Created by zzyong on 2019/11/8.
//  Copyright © 2019 zzyong. All rights reserved.
//

#import "ViewController.h"
#import "MyButton.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet MyButton *btn_1;

@property (weak, nonatomic) IBOutlet UIView *aView;

@property (assign, nonatomic) BOOL isAnimating;

@property (strong, nonatomic) UITapGestureRecognizer *doubleTapGesture;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.aView.layer.cornerRadius = self.aView.frame.size.width * 0.5;
    
    self.doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onDoubleTap:)];
    self.doubleTapGesture.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:self.doubleTapGesture];
}

- (void)onDoubleTap:(UITapGestureRecognizer *)doubleTapGesture
{
    NSLog(@"%s", __func__);
}

- (IBAction)onButton1Clicked:(MyButton *)sender
{
    NSLog(@"%s", __func__);
    
    if (self.isAnimating) {
        return;
    }
    self.isAnimating = YES;
    
    self.aView.transform = CGAffineTransformIdentity;
    [UIView animateWithDuration:0.5 animations:^{
        self.aView.transform = CGAffineTransformMakeScale(1.3, 1.3);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 animations:^{
            self.aView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            self.isAnimating = NO;
        }];
    }];
}

@end
