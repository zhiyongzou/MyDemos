//
//  main.m
//  AppLaunchDemo
//
//  Created by zzyong on 2020/5/8.
//  Copyright © 2020 zzyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <stdint.h>
#import <stdio.h>
#import <sanitizer/coverage_interface.h>
#import <dlfcn.h>

void __sanitizer_cov_trace_pc_guard_init(uint32_t *start, uint32_t *stop) {
    static uint32_t N;  // Counter for the guards.
    if (start == stop || *start) {
        // Initialize only once.
        return;
    }
    
    for (uint32_t *x = start; x < stop; x++) {
        *x = ++N;  // Guards should start from 1.
    }
    
    NSLog(@"INIT:[%p %p], Guards count:%d", start, stop, N);
}


void __sanitizer_cov_trace_pc_guard(uint32_t *guard) {

    void *PC = __builtin_return_address(0);
    
    Dl_info info;
    dladdr(PC, &info);
        
    NSLog(@"%s", info.dli_sname);
}


int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
