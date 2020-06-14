//
//  main.m
//  MetaClassDemo
//
//  Created by zzyong on 2019/11/18.
//  Copyright © 2019 zzyong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <objc/message.h>
#import "MetaClassB.h"
#import "MetaClassA.h"

// http://www.cocoawithlove.com/2010/01/what-is-meta-class-in-objective-c.html

void reportFunction(id self, SEL _cmd)
{
    NSLog(@"This object is %p.", self);
    NSLog(@"Class is %@, and super is %@.", [self class], [self superclass]);
    
    Class currentClass = [self class];
    for (int i = 1; i < 5; i++)
    {
        NSLog(@"Following the isa pointer %d times gives %p superClass: %p", i, currentClass, [currentClass superclass]);
        currentClass = object_getClass(currentClass);
    }
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        NSLog(@"");
        NSLog(@"NSObject's class is %p", [NSObject class]);
        NSLog(@"NSObject's meta class is %p", object_getClass([NSObject class]));
        
        NSLog(@"");
        NSLog(@"====================================MyError====================================");
        NSLog(@"");
        
        // Creating a class at runtime
        Class newClass = objc_allocateClassPair([NSError class], "MyError", 0);
        class_addMethod(newClass, @selector(report), (IMP)reportFunction, "v@:");
        objc_registerClassPair(newClass);
        
        id instanceOfNewClass = [[newClass alloc] initWithDomain:@"someDomain" code:0 userInfo:nil];
        [instanceOfNewClass performSelector:@selector(report)];
        
        NSLog(@"");
        NSLog(@"====================================MetaClassA====================================");
        NSLog(@"");
        
        class_addMethod([MetaClassA class], @selector(report), (IMP)reportFunction, "v@:");
        MetaClassA *aObj = [MetaClassA new];
        [aObj performSelector:@selector(report)];
        
        NSLog(@"");
        NSLog(@"====================================MetaClassB====================================");
        NSLog(@"");
        
        MetaClassB *bObj = [MetaClassB new];
        [bObj performSelector:@selector(report)];
    }
    return 0;
}
