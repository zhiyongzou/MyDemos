//
//  ViewController.m
//  MultithreadingDemo
//
//  Created by zzyong on 2020/6/2.
//  Copyright © 2020 zzyong. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    NSBlockOperation *op1 = [[NSBlockOperation alloc] init];
    [op1 addObserver:self forKeyPath:@"cancelled" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionNew context:NULL];
    [op1 addObserver:self forKeyPath:@"finished" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionNew context:NULL];
    [op1 addExecutionBlock:^{
       NSLog(@"Enter");
       
       sleep(10);
       
       NSLog(@"Leave");
    }];

    [queue addOperation:op1];
    
    NSLog(@"cancel");
    [op1 cancel];
//    [op1 performSelector:@selector(cancel) withObject:nil afterDelay:2];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    NSLog(@"%@ %@  %@", keyPath, object, change);
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
