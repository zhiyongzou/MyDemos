//
//  HBNewsViewController.m
//  HBullShares
//  Registered Name: https://zhile.io
//  License Key: 48891cf209c6d32bf4
//
//  Created by zzyong on 2020/7/31.
//  Copyright © 2020 zzyong. All rights reserved.
//

#import "HBNewsViewController.h"
#import "HBHttpManager.h"
#import "HBNewsCell.h"
#import "HBNewsModel.h"
#import "UIView+Extension.h"
#import "NSDictionary+Safe.h"
#import <NSObject+YYModel.h>
#import <MJRefresh.h>
#import <MJRefreshConfig.h>

@interface HBNewsViewController () < UICollectionViewDelegateFlowLayout, UICollectionViewDataSource >

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray<HBNewsModel *> *sharesNewsList;
@property (nonatomic, assign) NSUInteger currentPage;

@end

@implementation HBNewsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupCollectionView];
    [self refreshSharesNewsList];
}

#pragma mark - Private

- (void)setupCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds
                                                          collectionViewLayout:flowLayout];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.alwaysBounceVertical = YES;
    collectionView.showsVerticalScrollIndicator = NO;
    
    [collectionView registerClass:[HBNewsCell class] forCellWithReuseIdentifier:@"HBNewsCell"];
    
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    
    MJRefreshConfig.defaultConfig.languageCode = @"zh-Hans";
    __weak typeof(self) weakSelf = self;
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self refreshSharesNewsList];
    }];
    
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf queryMoreSharesNewsList];
    }];
    self.collectionView.mj_footer.hidden = YES;
}

- (NSDictionary *)queryParametersWithPage:(NSUInteger)page
{
    NSUInteger battery = arc4random()/100;
    NSTimeInterval timestamp = [NSDate date].timeIntervalSince1970;
    NSDictionary *parameters = @{
        @"app_key": @4135432745,
        @"type": @"stock",
        @"source": @"iphone_app",
        @"pdps_params": @{@"app":@{@"wifi_info":@{@"mac":@"",@"power":@"",@"name":@""},@"version":@"4.16.0.25",@"timestamp":@(timestamp).stringValue,@"osv":@"13.300000",@"targeting":@{},@"device_id_new":@"459EDC30-FC87-4DA7-9A9A-7CFBCCE01F1E",@"battery":@(battery).stringValue,@"os":@"iOS",@"device_type":@"4",@"size":@[@"1242*2688"],@"connection_type":@"2",@"ip":@"",@"make":@"apple",@"did":@"53c005ba00073275d210984b685825e16be1f4c9",@"device_id":@"53C005BA00073275D210984B685825E1",@"idfv":@"E0CC6F7F-FB49-4015-8DB4-513B10C42743",@"model":@"iPhone XS Max",@"carrier":@"中国移动",@"name":@"新浪财经"}},
        @"tm": @(timestamp),
        @"did": @"53c005ba00073275d210984b685825e16be1f4c9",
        @"net_type": @2,
        @"up": @(page),
        @"uid": @"",
        @"wm": @"b122",
        @"version": @"4.16.0",
        @"device_size": @"414*896",
        @"device_osv": @"13.300000",
        @"from": @"7049993012",
        @"action": @2,
        @"imei": @"3809361dab4555e1f22812142096005f",
        @"down": @4,
        @"device_os": @"iOS",
        @"zxtype": @"",
        @"chwm": @"3045_0100",
        @"device_model": @"iPhone XS Max",
        @"device_carrier": @"中国移动"
    };
    
    return parameters;
}

#pragma mark - UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.sharesNewsList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HBNewsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HBNewsCell" forIndexPath:indexPath];
    HBNewsModel *newsModel = [self.sharesNewsList objectAtIndex:indexPath.row];
    cell.newsModel = newsModel;
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(collectionView.width, [HBNewsCell cellHeight]);
}

#pragma mark - Data

- (void)refreshSharesNewsList
{
    self.currentPage = 0;
    [self querySharesNewsListWithPage:self.currentPage isMore:NO];
}

- (void)queryMoreSharesNewsList
{
    self.currentPage++;
    [self querySharesNewsListWithPage:self.currentPage isMore:YES];
}

- (void)querySharesNewsListWithPage:(NSUInteger)page isMore:(BOOL)isMore
{
    NSString *urlString = @"https://app.finance.sina.com.cn/news/tianyi/index";
    NSDictionary *parameters = [self queryParametersWithPage:page];
    
    __weak typeof(self) weakSelf = self;
    [HBHttpManager requestWithUrlString:urlString parameters:parameters success:^(id  _Nullable response) {
        [weakSelf handleSharesNewsListWithRsp:response isMore:isMore];
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

- (void)handleSharesNewsListWithRsp:(NSDictionary *)rsp isMore:(BOOL)isMore
{
    if (isMore) {
        [self.collectionView.mj_footer endRefreshing];
    } else {
        [self.collectionView.mj_header endRefreshing];
        self.collectionView.mj_footer.hidden = NO;
    }
    
    if (![rsp isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    NSDictionary *allData = [rsp dictionaryForKey:@"data"];
    NSDictionary *feed = [allData dictionaryForKey:@"feed"];
    NSArray<NSDictionary *> *sharesList = [feed arrayForKey:@"data"];
    
    NSArray *sharesListModel = [NSArray yy_modelArrayWithClass:[HBNewsModel class] json:sharesList];
    if (isMore) {
        NSMutableArray *allList = self.sharesNewsList ? [self.sharesNewsList mutableCopy] : [NSMutableArray array];
        if (sharesListModel) {
            [allList addObjectsFromArray:sharesListModel];
        }
        self.sharesNewsList = [allList copy];
    } else {
        self.sharesNewsList = sharesListModel;
    }
    
    [self.collectionView reloadData];
}

@end
