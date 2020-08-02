//
//  AppDelegate.m
//  HBullShares
//
//  Created by zzyong on 2020/7/31.
//  Copyright © 2020 zzyong. All rights reserved.
//

#ifdef DEBUG
    #import "AppDelegate+Debug.h"
#endif

#import "AppDelegate.h"

@interface AppDelegate ()


@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    #ifdef DEBUG
        [self debugInit];
    #endif
    
    return YES;
}

@end
