//
//  AppDelegate.m
//  HotFixDemo
//
//  Created by zzyong on 2020/6/11.
//  Copyright © 2020 zzyong. All rights reserved.
//

#import "AppDelegate.h"
#import <objc/runtime.h>
#import <objc/message.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

void sayHello(id self, SEL _cmd)
{
    NSLog(@"%@ %s", self, __func__);
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self addNewClassPair];
    
    Class MyObject = NSClassFromString(@"MyObject");
    NSObject *myObj = [[MyObject alloc] init];
    [myObj performSelector:@selector(sayHello)];
    
    [self methodReplace];
    [self methodExchange];

    return YES;
}

- (void)addNewClassPair
{
    Class myCls = objc_allocateClassPair([NSObject class], "MyObject", 0);
    objc_registerClassPair(myCls);
    [self addNewMethodWithClass:myCls];
}

- (void)addNewMethodWithClass:(Class)targetClass
{
    class_addMethod(targetClass, @selector(sayHello), (IMP)sayHello, "v@:");
}

- (void)methodReplace
{
    Method methodA = class_getInstanceMethod(self.class, @selector(myMethodA));
    IMP impA = method_getImplementation(methodA);
    class_replaceMethod(self.class, @selector(myMethodC), impA, method_getTypeEncoding(methodA));
    
    // print: myMethodA
    [self myMethodC];
}

- (void)methodExchange
{
    Method methodA = class_getInstanceMethod(self.class, @selector(myMethodA));
    Method methodB = class_getInstanceMethod(self.class, @selector(myMethodB));
    method_exchangeImplementations(methodA, methodB);
    
    // print: myMethodB
    [self myMethodA];
    
    // print: myMethodA
    [self myMethodB];
}

- (void)myMethodA
{
    NSLog(@"myMethodA");
}

- (void)myMethodB
{
    NSLog(@"myMethodB");
}

- (void)myMethodC
{
    NSLog(@"myMethodC");
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
