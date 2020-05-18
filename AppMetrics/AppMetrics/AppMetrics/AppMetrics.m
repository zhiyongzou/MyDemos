//
//  AppMetrics.m
//  AppMetrics
//
//  Created by zzyong on 2020/5/13.
//  Copyright © 2020 zzyong. All rights reserved.
//
// https://leetcode-cn.com/problemset/algorithms/

/**
 产生死锁的四个必要条件：
 （1）互斥条件：一个资源每次只能被一个进程使用。
 （2）请求与保持条件：一个进程因请求资源而阻塞时，对已获得的资源保持不放。
 （3）不剥夺条件:进程已获得的资源，在末使用完之前，不能强行剥夺。
 （4）循环等待条件:若干进程之间形成一种头尾相接的循环等待资源关系。
 这四个条件是死锁的必要条件，只要系统发生死锁，这些条件必然成立，而只要上述条件之
 一不满足，就不会发生死锁。
 
耗电监控
    iOS/macOS 的 Mach 内核提供了获取一个线程的使用信息的方法。这些信息记录在 thread_basic_info 结构体中：
     
    struct thread_basic_info {
        time_value_t   user_time;       // user run time
        time_value_t   system_time;     // system run time
        integer_t      cpu_usage;       // scaled cpu usage percentage
        policy_t       policy;          // scheduling policy in effect
        integer_t      run_state;       // run state (see below)
        integer_t      flags;           // various flags (see below)
        integer_t      suspend_count;   // suspend count for thread
        integer_t      sleep_time;      // number of seconds that thread  has been sleeping
    };
     
    耗电监控默认是当应用平均一分钟内 CPU 占用超过80%，把循环队列存储的堆栈组合成耗电堆栈。
 
 // Matrix-iOS 卡顿监控：https://cloud.tencent.com/developer/article/1427933
 常见卡顿场景
     1. 主线程在进行大量I/O操作：为了方便代码编写，直接在主线程去写入大量数据；
     2. 主线程在进行大量计算：代码编写不合理，主线程进行复杂计算；
     3. 大量UI绘制：界面过于复杂，UI绘制需要大量时间；
     4. 主线程在等锁：主线程需要获得锁A，但是当前某个子线程持有这个锁A，导致主线程不得不等待子线程完成任务。
 
 卡顿监控方案
    1. 主线程卡顿监控。通过子线程监测主线程的 runLoop，判断 kCFRunLoopBeforeSources 和 kCFRunLoopBeforeWaiting 区域之间的耗时是否达到一定阈值
    2. FPS监控。要保持流畅的UI交互，App 刷新率应该当努力保持在 60fps。监控实现原理比较简单，通过记录两次刷新时间间隔，就可以计算出当前的 FPS。
 */

#import "AppMetrics.h"
#import <CoreFoundation/CFRunLoop.h>

@implementation AppMetrics

+ (void)start
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
//        [AppMetrics registerRunLoopObserver];
    });
    
    @synchronized (self) {
           NSLog(@"111");
           @synchronized (self) {
               NSLog(@"222");
           }
       }
}

+ (void)registerRunLoopObserver
{
    NSRunLoop *curRunLoop = [NSRunLoop currentRunLoop];
    
    // the first observer
    CFRunLoopObserverContext context = {0, (__bridge void *)self, NULL, NULL, NULL};
    CFRunLoopObserverRef beginObserver = CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, LONG_MIN, &myRunLoopBeginCallback, &context);

    // the last observer
    CFRunLoopObserverRef endObserver = CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, LONG_MAX, &myRunLoopEndCallback, &context);

    CFRunLoopRef runloop = [curRunLoop getCFRunLoop];
    CFRunLoopAddObserver(runloop, beginObserver, kCFRunLoopCommonModes);
    CFRunLoopAddObserver(runloop, endObserver, kCFRunLoopCommonModes);
}

static void myRunLoopBeginCallback(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info)
{
    switch (activity) {
        case kCFRunLoopEntry:
            NSLog(@"kCFRunLoopEntry");
            break;

        case kCFRunLoopBeforeTimers:
            NSLog(@"kCFRunLoopBeforeTimers");
            break;

        case kCFRunLoopBeforeSources:
            NSLog(@"kCFRunLoopBeforeSources");
            break;

        case kCFRunLoopBeforeWaiting:
            NSLog(@"kCFRunLoopBeforeWaiting");
            break;
            
        case kCFRunLoopAfterWaiting:
            NSLog(@"kCFRunLoopAfterWaiting");
            break;

       case kCFRunLoopExit:
            NSLog(@"kCFRunLoopExit");
            break;
            
        case kCFRunLoopAllActivities:
            NSLog(@"kCFRunLoopAllActivities");
            break;
    }
}

void myRunLoopEndCallback(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info)
{
    switch (activity) {
        case kCFRunLoopBeforeWaiting:
            
            break;

        case kCFRunLoopExit:
            
            break;

        case kCFRunLoopAllActivities:
            break;

        default:
            break;
    }
}

@end
