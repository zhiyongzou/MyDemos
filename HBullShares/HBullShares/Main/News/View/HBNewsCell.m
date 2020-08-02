//
//  HBNewsCell.m
//  HBullShares
//
//  Created by zzyong on 2020/8/1.
//  Copyright © 2020 zzyong. All rights reserved.
//

#import "HBNewsCell.h"
#import <Masonry.h>
#import <HexColors.h>
#import "HBNewsModel.h"
#import "NSString+Time.h"
#import <UIImageView+WebCache.h>

#define HBNewsIconHeight     63.0
#define HBNewsIconWidth      112.0
#define HBNewsCommonSpacing  10.0

@interface HBNewsCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *sourceLabel;
@property (nonatomic, strong) UIView *bottomLine;

@end

@implementation HBNewsCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupSubviews];
    }
    return self;
}

#pragma mark - Private

- (void)setupSubviews
{
    self.iconView = [[UIImageView alloc] init];
    self.iconView.layer.cornerRadius = 5;
    self.iconView.layer.masksToBounds = YES;
    self.iconView.layer.borderColor = [UIColor colorWithWhite:0.95 alpha:1].CGColor;
    self.iconView.layer.borderWidth = 1;
    [self.contentView addSubview:self.iconView];
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(HBNewsIconWidth);
        make.height.mas_equalTo(HBNewsIconHeight);
        make.right.equalTo(self.contentView).offset(-HBNewsCommonSpacing);
        make.centerY.equalTo(self.contentView);
    }];
    
    self.sourceLabel = [[UILabel alloc] init];
    self.sourceLabel.font = [UIFont boldSystemFontOfSize:12];
    self.sourceLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:self.sourceLabel];
    [self.sourceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(HBNewsCommonSpacing);
        make.bottom.equalTo(self.contentView).offset(-HBNewsCommonSpacing);
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.numberOfLines = 2;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    self.titleLabel.textColor = [UIColor hx_colorWithHexString:@"333333"];
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.contentView).offset(HBNewsCommonSpacing);
        make.right.equalTo(self.iconView.mas_left).offset(-5);
    }];
    
    self.bottomLine = [[UIView alloc] init];
    self.bottomLine.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    [self.contentView addSubview:self.bottomLine];
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.left.equalTo(self.contentView).offset(HBNewsCommonSpacing);
        make.right.equalTo(self.contentView).offset(-HBNewsCommonSpacing);
        make.bottom.equalTo(self.contentView);
    }];
}

- (void)setNewsModel:(HBNewsModel *)newsModel
{
    _newsModel = newsModel;
    
    self.titleLabel.text = newsModel.title;
    NSString *iconUrl = newsModel.thumbs.firstObject;
    if (iconUrl.length == 0) {
        self.iconView.hidden = YES;
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self.contentView).offset(HBNewsCommonSpacing);
            make.right.equalTo(self.contentView).offset(-HBNewsCommonSpacing);
        }];
    } else {
        self.iconView.hidden = NO;
        [self.iconView sd_setImageWithURL:[NSURL URLWithString:iconUrl] placeholderImage:nil];
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self.contentView).offset(HBNewsCommonSpacing);
            make.right.equalTo(self.iconView.mas_left).offset(-5);
        }];
    }
    NSString *sourceText = newsModel.author ?: @"";
    sourceText = [sourceText stringByAppendingFormat:@" %@", [NSString timeLineStringByDate:[NSDate dateWithTimeIntervalSince1970:newsModel.timestamp]]];
    self.sourceLabel.text = sourceText;
}

+ (CGFloat)cellHeight
{
    return HBNewsIconHeight + 20;
}

@end
