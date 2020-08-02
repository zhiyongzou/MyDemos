//
//  UIView+Extension.h
//  HBullShares
//
//  Created by zzyong on 2020/8/1.
//  Copyright © 2020 zzyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (HB_Layout)

@property(nonatomic, assign) CGFloat x;
@property(nonatomic, assign) CGFloat y;
@property(nonatomic, assign) CGFloat width;
@property(nonatomic, assign) CGFloat height;
@property(nonatomic, assign) CGSize size;

@end

@interface UIView (HB_Common)

- (void)removeAllSubViews;

@end
