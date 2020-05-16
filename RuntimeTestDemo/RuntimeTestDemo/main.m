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

/// 调用父类类方法
void callSuperClassMethod()
{
    // MyClassB 继承 MyClassA
    // 获取元类
    Class metaClass = object_getClass([MyClassB class]);
    // 获取元类父类
    Class superCls = [metaClass superclass];
    
    SEL superSel = @selector(sayHelloWorld);
    SEL superAliasSel = sel_registerName("super_sayHelloWorld");
    
    // 获取父类类方法 Method
    Method superMethod = class_getInstanceMethod(superCls, superSel);
    // 获取父类类方法 IMP
    IMP superIMP = method_getImplementation(superMethod);
    
    // 子类新增加父类方法
    BOOL addMethodSuccess = class_addMethod([metaClass class], superAliasSel, superIMP, method_getTypeEncoding(superMethod));
    NSLog(@"class_addMethod success: %d", addMethodSuccess);
    
    [MyClassB performSelector:superAliasSel];
}

void metaClassTest()
{
    // 类对像的类是元类
    BOOL res1 = [[NSObject class] isKindOfClass:[NSObject class]];
    BOOL res2 = [[NSObject class] isMemberOfClass:[objc_getMetaClass("NSObject") class]];
    BOOL res3 = [[MyClassB class] isKindOfClass:[objc_getMetaClass("MyClassB") class]];
    BOOL res4 = [[MyClassB class] isMemberOfClass:[objc_getMetaClass("MyClassB") class]];
    NSLog(@"%@ - %@ - %@ - %@", @(res1), @(res2), @(res3), @(res4));
    
    // 根类的的父类就是自己
    [NSObject hello];
}

void isaTest()
{
    MyClassA *obj = [MyClassA new];
    NSLog(@"%p", obj);
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        callSuperClassMethod();
        metaClassTest();
        isaTest();
        
    }
    return 0;
}
