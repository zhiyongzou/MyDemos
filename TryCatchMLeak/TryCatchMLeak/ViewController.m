//
//  ViewController.m
//  TryCatchMLeak
//
//  Created by zzyong on 2020/5/11.
//  Copyright © 2020 zzyong. All rights reserved.
//

#import "ViewController.h"
#import "MyObject.h"

@interface ViewController ()


@end

@implementation ViewController

- (void)dealloc
{
    NSLog(@"%s", __func__);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    @try {
        MyObject *obj = [MyObject new];
        [obj description];

        @throw [NSException exceptionWithName:@"ML" reason:@"Memory Leak" userInfo:@{}];
    } @catch (NSException *exception) {
        NSLog(@"%@", exception);
    } @finally {
        NSLog(@"finally call");
    }
    
    
    {
        ViewController *vc = [ViewController new];
        vc.myObject = [MyObject new];

        @try {
            [vc.myObject removeObserver:self forKeyPath:@"Unknown name"];
        } @catch (NSException *exception) {
            NSLog(@"%@", exception);
        } @finally {
            NSLog(@"finally call");
        }
    }
}


@end
