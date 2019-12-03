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

    }
    return 0;
}
