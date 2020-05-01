//
//  main.m
//  RuntimeTestDemo
//
//  Created by zzyong on 2019/12/3.
//  Copyright © 2019 zzyong. All rights reserved.
//

#import "MyClassB.h"
#import <objc/runtime.h>
#import <Foundation/Foundation.h>
#import "NSObject+Runtime.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        Class metaClass = object_getClass([MyClassB class]);
        Class superCls = [metaClass superclass];
        SEL superSel = @selector(sayHelloWorld);
        SEL superAliasSel = @selector(super_sayHelloWorld);
        Method superMethod = class_getInstanceMethod(superCls, superSel);
        IMP superIMP = method_getImplementation(superMethod);
        BOOL addMethodSuccess = class_addMethod([metaClass class], superAliasSel, superIMP, method_getTypeEncoding(superMethod));
        NSLog(@"success: %d", addMethodSuccess);
        
        [MyClassB performSelector:superAliasSel];
        
        
        BOOL res1 = [[NSObject class] isKindOfClass:[NSObject class]];
        BOOL res2 = [[NSObject class] isMemberOfClass:[objc_getMetaClass("NSObject") class]];
        BOOL res3 = [[MyClassB class] isKindOfClass:[objc_getMetaClass("MyClassB") class]];
        BOOL res4 = [[MyClassB class] isMemberOfClass:[MyClassB class]];
        NSLog(@"%@ - %@ - %@ - %@", @(res1), @(res2), @(res3), @(res4));
        
        [NSObject hello];
        [[NSObject new] performSelector:@selector(hello)];
        
        

    }
    return 0;
}
