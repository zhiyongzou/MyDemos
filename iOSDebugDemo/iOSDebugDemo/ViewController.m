//
//  ViewController.m
//  iOSDebugDemo
//
//  Created by zzyong on 2020/4/26.
//  Copyright © 2020 zzyong. All rights reserved.
//

#import "ViewController.h"
#import "iOSDebugDemo-Swift.h"
#import "MyView1.h"

@interface ViewController ()

@property (nonatomic, assign) NSUInteger myNumber;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self swiftErrorBreakpoint];
    [self symbolicBreakpoint];
    c_func();
    [self enumerateArray];
    [self increaseMyNumber];
    
    for (int idx = 0; idx < 5; idx++) {
        [self logMag:[NSString stringWithFormat:@"%@ Say Hello", @(idx)]];
    }
}

- (void)logMag:(NSString *)msg
{
    __unused NSString *firstChar = [msg substringToIndex:1];
}

- (void)increaseMyNumber
{
    self.myNumber++;
    
    static int loop = 0;
    if (loop < 5) {
        [self performSelector:@selector(increaseMyNumber) withObject:nil afterDelay:1];
        loop++;
    }
    NSLog(@"myNumber: %@", @(self.myNumber));
}

- (void)symbolicBreakpoint
{
    MyView1 *view = [MyView1 new];
    [view sayHello];
    [self.view addSubview:view];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [view removeFromSuperview];
    });
}

- (void)swiftErrorBreakpoint
{
    MyView *view = [[MyView alloc] init];
    [view throwRrrorAndReturnError:NULL];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self arrayException];
}

- (void)arrayException
{
    [@[] objectAtIndex:1];
}

- (void)enumerateArray
{
    [@[@1, @2, @3, @4, @5] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"current obj: %@", obj);
    }];
}

void c_func()
{
    NSLog(@"%s", __func__);
}


@end
