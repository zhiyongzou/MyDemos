//
//  main.m
//  AppLaunchDemo
//
//  Created by zzyong on 2020/5/8.
//  Copyright © 2020 zzyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#include <stdint.h>
#include <stdio.h>
#include <sanitizer/coverage_interface.h>


void __sanitizer_cov_trace_pc_guard_init(uint64_t *start, uint64_t *stop) {
    static uint64_t N;  // Counter for the guards.
    if (start == stop || *start) {
        // Initialize only once.
        return;
    }
    
    printf("INIT: %p %p\n", start, stop);
    
    for (uint64_t *x = start; x < stop; x++) {
        *x = ++N;  // Guards should start from 1.
    }
}


void __sanitizer_cov_trace_pc_guard(uint32_t *guard) {
    if (!*guard) {
        return;  // Duplicate the guard check.
    }
    printf("guard: %p %x PC\n", guard, *guard);
}


int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
