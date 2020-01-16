//
//  main.m
//  objc_msgSend_hook
//
//  Created by zzyong on 2020/1/10.
//  Copyright © 2020 zzyong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "fishhook.h"
#import <objc/runtime.h>
#import <objc/message.h>

static id _Nullable orig_objc_msgSend(id _Nullable self, SEL _Nonnull op, ...);

id _Nullable my_objc_msgSend(id _Nullable self, SEL _Nonnull op, ...) {
    return nil;
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
    }
    return 0;
}
