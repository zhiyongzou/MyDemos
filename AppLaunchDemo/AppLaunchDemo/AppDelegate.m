//
//  AppDelegate.m
//  AppLaunchDemo
//
//  Created by zzyong on 2020/5/8.
//  Copyright © 2020 zzyong. All rights reserved.
//

#import "AppDelegate.h"
#import <os/signpost.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    const char *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier].UTF8String;
    os_log_t logger = os_log_create(bundleIdentifier, "performance");
    os_signpost_id_t signPostId = os_signpost_id_make_with_pointer(logger, NULL);
    
    for (int idx = 0; idx < 1000; idx++) {
        
        //标记时间段开始
        os_signpost_interval_begin(logger, signPostId, "Launch", "%{public}d", idx);
        
        NSLog(@"%@", [NSString stringWithFormat:@"zzy - %d", idx]);
        
        //标记结束
        os_signpost_interval_end(logger, signPostId, "Launch");
    }
    
    
    // Override point for customization after application launch.
    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
