//
//  CVLabelCell.m
//  CollectionViewAnimationDemo
//
//  Created by zzyong on 2020/6/18.
//  Copyright © 2020 zzyong. All rights reserved.
//

#import "CVLabelCell.h"

@implementation CVLabelCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor lightGrayColor];
        self.textLabel = [UILabel new];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:self.textLabel];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.textLabel.frame = self.contentView.bounds;
}

@end
