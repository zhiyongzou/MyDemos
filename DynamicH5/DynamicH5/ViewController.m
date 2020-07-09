//
//  ViewController.m
//  DynamicH5
//
//  Created by zzyong on 2020/7/9.
//  Copyright © 2020 zzyong. All rights reserved.
//

#import "Aspects.h"
#import <WebKit/WebKit.h>
#import "ViewController.h"
#import <objc/runtime.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (WKWebViewConfiguration *)webViewConfiguration
{
    return [[WKWebViewConfiguration alloc] init];
}

- (void)queryDyConfig
{
    // 后台配置
    NSDictionary *config = @[
        
        @{
            @"msg": @"self.webViewConfiguration",
            @"localKey": @[@"config"]
        },
        
        @{
            @"msg": @"self.bounds",
            @"localKey": @"bounds"
        },
        
        @{
            @"msg": @"WKWebView.alloc.initWithFrame:configuration:",
            @"arguments": @[@"bounds", @"config"],
            @"localKey": @[@"webViewConfiguration"]
        },
        
        @{
            @"msg": @"self.view.addSubview:",
            @"arguments": @[@"customView"]
        }
    ];
}

- (void)invokeConfigMsgs:(NSArray<NSDictionary *> *)msgs
{
    NSMutableDictionary *localInatances = [NSMutableDictionary dictionary];
    [msgs enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull msg, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *msgString = [msg objectForKey:@"msg"];
        NSArray<NSString *> *msgComponents = [msgString componentsSeparatedByString:@"."];
        
        __block id currentTarget = nil;
        [msgComponents enumerateObjectsUsingBlock:^(NSString * _Nonnull component, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if (idx == 0) {
                if ([component isEqualToString:@"self"]) {
                    currentTarget = self;
                } else {
                    currentTarget = NSClassFromString(component);
                }
            } else {
                SEL selector = sel_registerName([component UTF8String]);
                
                NSMethodSignature *signature = nil;
                if (object_isClass(currentTarget)) {
                    signature = [[currentTarget class] methodSignatureForSelector:selector];
                } else {
                    signature = [[currentTarget class] instanceMethodSignatureForSelector:selector];
                }
                
                if (!signature) {
                    NSAssert(NO, @"Target:[%@] method signature must not be nil. selName:%@", currentTarget, component);
                    return;
                }
                
                NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
                invocation.target = currentTarget;
                invocation.selector = selector;
            }
        }];
    }];
}

+ (id )invokeMethodWithTarget:(id)target selName:(NSString *)selName isClassMethod:(BOOL)isClassMethod arguments:(NSArray *)arguments
{
    id localInstance = nil;
    SEL selector = sel_registerName([selName UTF8String]);
    
    NSMethodSignature *signature = nil;
    
    if (isClassMethod) {
        
        signature = [[target class] methodSignatureForSelector:selector];
    } else {
        
        signature = [[target class] instanceMethodSignatureForSelector:selector];
    }
    
    if (!signature) {
        NSAssert(NO, @"[JPAspect] Target:[%@] method signature must not be nil. selName:%@", target, selName);
        return localInstance;
    }
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = target;
    invocation.selector = selector;
    
    if (arguments) {
        for (id argument in arguments) {
            if (aspectArgument.type == JPArgumentTypeObject) {
                id value = aspectArgument.value;
                [invocation setArgument:&value atIndex:argumentIndex];
            }
        }
    }
    
    [invocation invoke];
    
    const char *methodReturnType = signature.methodReturnType;
    if (strcmp(methodReturnType, @encode(id)) == 0) {
        
        if ([selName isEqualToString:@"alloc"])  {
            
            localInstance = [[target class] alloc];
            
        }  else {
            void *result;
            [invocation getReturnValue:&result];
            localInstance = (__bridge id)result;
        }
        
    }  else if (strcmp(methodReturnType, @encode(CGRect)) == 0) {
        
        CGRect result = CGRectZero;
        [invocation getReturnValue:&result];
        localInstance = [NSValue valueWithCGRect:result];
    }
    
    invocation.target = nil;
    
    return localInstance;
}



@end
