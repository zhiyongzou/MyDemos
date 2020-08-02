//
//  AppDelegate+Debug.m
//  HBullShares
//
//  Created by zzyong on 2020/8/2.
//  Copyright © 2020 zzyong. All rights reserved.
//

#ifdef DEBUG

#import <FLEX.h>
#import "AppDelegate+Debug.h"

static UIWindow *flexWindow;

@implementation AppDelegate (Debug)

- (void)debugInit
{
    [self addFLEX];
}

- (UIWindow *)flexWindow
{
    return flexWindow;
}

- (void)addFLEX
{
    flexWindow = [[UIWindow alloc] init];
    flexWindow.backgroundColor = [UIColor clearColor];
    flexWindow.rootViewController = [[UIViewController alloc] init];
    flexWindow.windowLevel = UIWindowLevelStatusBar + 50;
    CGFloat windowY = CGRectGetMaxY([UIApplication sharedApplication].statusBarFrame);
    flexWindow.frame = CGRectMake(0.5 * ([UIScreen mainScreen].bounds.size.width - 30), windowY, 30, 13);
    [flexWindow makeKeyAndVisible];
    
    UIButton *flexBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    flexBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [flexBtn setTitle:@"FLEX" forState:UIControlStateNormal];
    [flexBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [flexBtn addTarget:self action:@selector(showFlexSettingView) forControlEvents:UIControlEventTouchUpInside];
    flexBtn.frame = flexWindow.bounds;
    [flexWindow addSubview:flexBtn];
}

-(void)showFlexSettingView
{
    [[FLEXManager sharedManager] showExplorer];
}


@end

#endif
