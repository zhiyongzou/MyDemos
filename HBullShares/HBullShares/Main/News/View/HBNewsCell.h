//
//  HBNewsCell.h
//  HBullShares
//
//  Created by zzyong on 2020/8/1.
//  Copyright © 2020 zzyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HBNewsModel;

NS_ASSUME_NONNULL_BEGIN

@interface HBNewsCell : UICollectionViewCell

@property (nonatomic, strong) HBNewsModel *newsModel;

+ (CGFloat)cellHeight;

@end

NS_ASSUME_NONNULL_END
