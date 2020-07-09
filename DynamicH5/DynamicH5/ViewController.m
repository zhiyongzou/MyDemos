//
//  ViewController.m
//  DynamicH5
//
//  Created by zzyong on 2020/7/9.
//  Copyright © 2020 zzyong. All rights reserved.
//

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
    
    [self queryConfig];
}

- (void)queryConfig
{
    // 下发一个json 转换成对应的 config 字典即可
    // 后台配置
    NSDictionary *config = @{
        
        @"clsList": @[@"WKWebViewConfiguration", @"WKWebView", @"NSURL", @"NSURLRequest"],
        @"msgs": @[
            @{
                // WKWebViewConfiguration *config = [WKWebViewConfiguration alloc] init]
                @"msg": @"WKWebViewConfiguration.alloc.init",
                @"localKey": @"config"
            },
            
            @{
                // CGRect bounds = self.view.bounds;
                @"msg": @"self.view.bounds",
                @"localKey": @"bounds"
            },
            
            @{
                // WKWebView *customView = [[WKWebView alloc] initWithFrame:bounds configuration:config]
                @"msg": @"WKWebView.alloc.initWithFrame:configuration:",
                @"arguments": @[@"bounds", @"config"],
                @"localKey": @"customView"
            },
            
            @{
                // NSURL *linkUrl = [NSURL URLWithString:@"https://www.baidu.com/"];
                @"msg": @"NSURL.URLWithString:",
                @"arguments": @[@"https://www.baidu.com/"],
                @"localKey": @"linkUrl"
            },
            
            @{
                // NSURLRequest *request = [NSURLRequest requestWithURL:linkUrl];
                @"msg": @"NSURLRequest.requestWithURL:",
                @"arguments": @[@"linkUrl"],
                @"localKey": @"request"
            },
            
            @{
                // [customView loadRequest:request];
                @"msg": @"customView.loadRequest:",
                @"arguments": @[@"request"]
            },
            
            @{
                // [self.view addSubview:customView];
                @"msg": @"self.view.addSubview:",
                @"arguments": @[@"customView"]
            }
        ]
    };
    
    [self invokeConfigMsgs:config[@"msgs"] clsList:config[@"clsList"]];
}

- (void)invokeConfigMsgs:(NSArray<NSDictionary *> *)msgs clsList:(NSArray<NSString *> *)clsList
{
    NSMutableDictionary *localInatances = [NSMutableDictionary dictionary];
    
    [msgs enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull msg, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString *localKey = [msg objectForKey:@"localKey"];
        NSArray<NSString *> *arguments = [msg objectForKey:@"arguments"];
        NSString *msgString = [msg objectForKey:@"msg"];
        NSArray<NSString *> *msgComponents = [msgString componentsSeparatedByString:@"."];
        id currentTarget = nil;
        
        for (NSString *component in msgComponents) {
            if (currentTarget == nil) {
                if ([component isEqualToString:@"self"]) {
                    currentTarget = self;
                } else if ([clsList containsObject:component]) {
                    currentTarget = NSClassFromString(component);
                } else {
                    currentTarget = [localInatances objectForKey:component];
                }
                
                if (currentTarget == nil) {
                    NSAssert(NO, @"%@ is not exist", component);
                    return;
                }
                
            } else {
                if ([component isEqualToString:@"alloc"])  {
                    currentTarget = [[currentTarget class] alloc];
                    continue;
                }
                
                SEL selector = sel_registerName([component UTF8String]);
                
                NSMethodSignature *signature = nil;
                if (object_isClass(currentTarget)) {
                    signature = [[currentTarget class] methodSignatureForSelector:selector];
                } else {
                    signature = [[currentTarget class] instanceMethodSignatureForSelector:selector];
                }
                
                if (!signature) {
                    NSAssert(NO, @"signature is nil");
                    return;
                }
                
                NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
                invocation.target = currentTarget;
                invocation.selector = selector;
                
                if (arguments && [component isEqualToString:msgComponents.lastObject]) {
                    for (int idx = 0; idx < arguments.count; idx++) {
                        NSString *argument = [arguments objectAtIndex:idx];
                        id argumentValue = [localInatances objectForKey:argument];
                        
                        if (argumentValue == nil) {
                            // 字符串类型
                            argumentValue = argument;
                        }
                        
                        if ([argumentValue isKindOfClass:[NSValue class]]) {
                            CGRect frame = [(NSValue *)argumentValue CGRectValue];
                            [invocation setArgument:&frame atIndex:idx+2];
                        } else {
                            [invocation setArgument:&argumentValue atIndex:idx+2];
                        }
                    }
                }
                
                [invocation invoke];
                
                const char *methodReturnType = signature.methodReturnType;
                if (strcmp(methodReturnType, @encode(id)) == 0) {
                    
                    void *result;
                    [invocation getReturnValue:&result];
                    currentTarget = (__bridge id)result;
                    
                }  else if (strcmp(methodReturnType, @encode(CGRect)) == 0) {
                    
                    CGRect result = CGRectZero;
                    [invocation getReturnValue:&result];
                    currentTarget = [NSValue valueWithCGRect:result];
                }
                
                invocation.target = nil;
            }
        }
        
        if (localKey && currentTarget) {
            [localInatances setObject:currentTarget forKey:localKey];
        }
    }];
}


@end
