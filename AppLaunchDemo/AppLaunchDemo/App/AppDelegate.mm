//
//  AppDelegate.m
//  AppLaunchDemo
//
//  Created by zzyong on 2020/5/8.
//  Copyright © 2020 zzyong. All rights reserved.
//

/**
  Write Link Map File : 生成 LinkMap 文件
  Path to Link Map File : 设置  LinkMap 文件生成路径
 */

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

+ (void)load
{
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Enable Objective-C Exceptions : 关闭 OC 异常
    // C++ 指定文件设置捕获异常：-fexceptions
    // -fno-exceptions
    // 使用 C++ 异常捕获
//    try {
//        [application removeObserver:self forKeyPath:@"Unknown Name"];
//    } catch (NSException *exception) {
//        NSLog(@"%@", exception);
//    }
    
    // Override point for customization after application launch.
    
    [self launchDoSomething];
    return YES;
    
    // 查看 Xcode 环境变量
    // xcodebuild -project AppLaunchDemo.xcodeproj -target AppLaunchDemo -configuration Debug -showBuildSettings > xcodebuild_showBuildSettings.txt
    
    // PROJECT_DIR : 项目目录路径
    
    // SanitizerCoverage：http://clang.llvm.org/docs/SanitizerCoverage.html
    
    /**
     extern "C"的主要作用就是为了能够正确实现C++代码调用其他C语言代码。加上extern "C"后，会指示编译器这部分代码按C语言的进行编译，而不是C++的。
     由于C++支持函数重载，因此编译器编译函数的过程中会将函数的参数类型也加到编译后的代码中，而不仅仅是函数名；而C语言并不支持函数重载，因此编译C语言代码的函数时不会带上函数的参数类型，一般只包括函数名。
     */
}

- (void)launchDoSomething
{
    
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
