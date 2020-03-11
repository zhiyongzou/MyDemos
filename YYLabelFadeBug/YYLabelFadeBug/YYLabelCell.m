//
//  YYLabelCell.m
//  YYLabelFadeBug
//
//  Created by zzyong on 2020/3/11.
//  Copyright © 2020 zzyong. All rights reserved.
//

#import "YYLabelCell.h"
#import <YYText/YYLabel.h>

@interface YYLabelCell ()

@property (nonatomic, strong) YYLabel *contentLabel;

@end

@implementation YYLabelCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.contentLabel];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.contentLabel.frame = self.contentView.bounds;
}

- (YYLabel *)contentLabel
{
    if (!_contentLabel) {
        
        _contentLabel = [[YYLabel alloc] init];
        _contentLabel.numberOfLines = 0;
        _contentLabel.fadeOnHighlight = NO;
        _contentLabel.textTapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            NSLog(@"%@", text);
        };
    }
    
    return _contentLabel;
}

- (void)setRichContent:(NSAttributedString *)richContent
{
    _richContent = richContent;
    
    self.contentLabel.attributedText = richContent;
}

@end
