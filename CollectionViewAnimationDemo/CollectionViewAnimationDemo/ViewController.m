//
//  ViewController.m
//  CollectionViewAnimationDemo
//
//  Created by zzyong on 2020/6/18.
//  Copyright © 2020 zzyong. All rights reserved.
//

#import "ViewController.h"
#import "CVLabelCell.h"
#import "CVAnimationFlowLayout.h"

@interface ViewController ()<UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) NSUInteger itemCount;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.itemCount = 10;
    [self setupCollectionView];
}

- (IBAction)insertCell:(UIBarButtonItem *)sender
{
    self.itemCount ++;
    
    [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]]];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.collectionView.frame = CGRectMake(50, self.view.safeAreaInsets.top, 50, 325);
}

- (void)setupCollectionView
{
    CVAnimationFlowLayout *flowLayout = [[CVAnimationFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 10;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                                          collectionViewLayout:flowLayout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.pagingEnabled = YES;
    collectionView.showsVerticalScrollIndicator = NO;
    
    [collectionView registerClass:[CVLabelCell class] forCellWithReuseIdentifier:@"CVLabelCell"];
    
    self.collectionView = collectionView;
    
    [self.view addSubview:collectionView];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.itemCount;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CVLabelCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CVLabelCell" forIndexPath:indexPath];
    cell.textLabel.text = @(indexPath.item).stringValue;
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(50, 50);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.itemCount--;
    [collectionView deleteItemsAtIndexPaths:@[indexPath]];
}

@end
