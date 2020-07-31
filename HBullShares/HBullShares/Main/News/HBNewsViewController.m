//
//  HBNewsViewController.m
//  HBullShares
//
//  Created by zzyong on 2020/7/31.
//  Copyright © 2020 zzyong. All rights reserved.
//

#import "HBNewsViewController.h"
#import "HBHttpManager.h"

@interface HBNewsViewController ()

@end

@implementation HBNewsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self querySharesNewsList];
}

- (void)querySharesNewsList
{
    NSString *urlString = @"http://jgjc.ndrc.gov.cn/dmzs.aspx?clmId=741";
    [HBHttpManager requestWithUrlString:urlString parameters:nil success:^(id  _Nullable response) {
        NSLog(@"%@", response);
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

@end
