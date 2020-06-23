//
//  CCRoomAwardListView.h
//  CC-iPhone
//
//  Created by zzyong on 2020/6/18.
//  Copyright © 2020 netease. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CCRoomAwardViewSize 50.0

typedef NS_ENUM(NSInteger, CCRoomAwardListViewScrollDirection) {
    CCRoomAwardListViewScrollVertical   = 0,
    CCRoomAwardListViewScrollHorizontal = 1
};

NS_ASSUME_NONNULL_BEGIN

@interface CCRoomAwardListView : UIView

/// 子视图间距，默认: 10
@property (nonatomic, assign) CGFloat itemSpacing;

@property (nonatomic, assign) CCRoomAwardListViewScrollDirection scrollDirection;
/// 插入动画掉落高度，默认：CCRoomAwardViewSize
@property (nonatomic, assign) CGFloat dropOffset;


/// 插入奖励插件视图
/// @param awardView 奖励视图
/// @param animated 是否需要动画
/// @param key 视图Key
- (void)insertAwardView:(UIView *)awardView withKey:(NSString *)key animated:(BOOL)animated;

- (void)insertAwardView:(UIView *)awardView withKey:(NSString *)key;

- (void)deleteAwardViewWithKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
