//
//  CCRoomAwardListView.m
//  CC-iPhone
//
//  Created by zzyong on 2020/6/18.
//  Copyright © 2020 netease. All rights reserved.
//

#import "CCRoomAwardListView.h"
#import <UIView+JHChainableAnimations.h>

@interface CCRoomAwardListView ()

@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) NSMutableArray<NSString *> *insertQueue;
@property (nonatomic, strong) NSMutableDictionary<NSString *, UIView*> *awardViewsMap;
/// 正在插入
@property (nonatomic, assign) BOOL isInserting;

@end

@implementation CCRoomAwardListView

- (instancetype)init
{
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        self.itemSpacing = 10;
        self.clipsToBounds = NO;
        self.dropOffset = CCRoomAwardViewSize;
        self.scrollDirection = CCRoomAwardListViewScrollVertical;
        
        self.contentScrollView = [[UIScrollView alloc] init];
        self.contentScrollView.showsVerticalScrollIndicator = NO;
        self.contentScrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:self.contentScrollView];
        
#ifdef DEBUG
        self.layer.borderColor = [UIColor orangeColor].CGColor;
        self.layer.borderWidth = 1.0;
        UIButton *add = [UIButton buttonWithType:UIButtonTypeContactAdd];
        add.backgroundColor = [UIColor grayColor];
        [self addSubview:add];
        [add addTarget:self action:@selector(addAwardView) forControlEvents:UIControlEventTouchUpInside];
#endif
    }
    
    return self;
}

#ifdef DEBUG
- (void)addAwardView
{
    static NSInteger index = 0;
    UILabel *aView = [UILabel new];
    aView.text = @(index).stringValue;
    aView.tag = index;
    aView.userInteractionEnabled = YES;
    aView.textColor = [UIColor orangeColor];
    aView.textAlignment = NSTextAlignmentCenter;
    aView.backgroundColor = [UIColor systemBlueColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
    [aView addGestureRecognizer:tap];
    [self insertAwardView:aView withKey:@(index).stringValue animated:YES];
    index++;
}

- (void)didTap:(UITapGestureRecognizer *)tapGesture
{
    UIView *targetView = tapGesture.view;
    
    [self deleteAwardViewWithKey:@(targetView.tag).stringValue];
}
#endif

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.contentScrollView.frame = self.bounds;
}

- (NSMutableDictionary<NSString *,UIView *> *)awardViewsMap
{
    if (_awardViewsMap == nil) {
        _awardViewsMap = [[NSMutableDictionary alloc] init];
    }
    
    return _awardViewsMap;
}

- (NSMutableArray<NSString *> *)insertQueue
{
    if (_insertQueue == nil) {
        _insertQueue = [NSMutableArray array];
    }
    
    return _insertQueue;
}

- (void)setIsInserting:(BOOL)isInserting
{
    _isInserting = isInserting;
    
    if (isInserting == NO && _insertQueue.count > 0) {
        
        BOOL isAnimated = _insertQueue.count == 1;
        NSString *key = _insertQueue.firstObject;
        [_insertQueue removeObject:key];
        
        [self insertAwardView:[self.awardViewsMap objectForKey:key] withKey:key animated:isAnimated];
    }
}

- (void)insertAwardView:(UIView *)awardView withKey:(NSString *)key
{
    [self insertAwardView:awardView withKey:key animated:YES];
}

- (void)insertAwardView:(UIView *)awardView withKey:(NSString *)key animated:(BOOL)animated
{
    if (awardView == nil || key == nil) {
        NSAssert(NO, @"");
        return;
    }
    
    [self.awardViewsMap setObject:awardView forKey:key];
    [self.contentScrollView addSubview:awardView];
    
    if (self.isInserting) {
        [self.insertQueue addObject:key];
        return;
    }
    self.isInserting = YES;
    
    CGFloat scrollOffset = CCRoomAwardViewSize + self.itemSpacing;
    BOOL isVertical = CCRoomAwardListViewScrollVertical == _scrollDirection;
    NSInteger numberAfterAdded = self.contentScrollView.subviews.count;
    
    // 更新 contentSize
    CGFloat contentHeight = 0;
    CGFloat contentWidth = 0;
    if (isVertical) {
        contentHeight = (numberAfterAdded * CCRoomAwardViewSize) + ((numberAfterAdded - 1) * self.itemSpacing);
        contentWidth = CCRoomAwardViewSize;
    } else {
        contentHeight = CCRoomAwardViewSize;
        contentWidth = (numberAfterAdded * CCRoomAwardViewSize) + ((numberAfterAdded - 1) * self.itemSpacing);
    }
    self.contentScrollView.contentSize = CGSizeMake(contentWidth, contentHeight);
    
    // 滚动至顶部
    [self.contentScrollView setContentOffset:CGPointZero animated:NO];
    
    // 竖向掉落
    if (isVertical) {
        
        if (animated) {
            [self handleVerticalInsertAnimationWithtView:awardView];
        } else {
            // 确定第一个子视图 Y 值
            __block CGFloat firstSubviewY = contentHeight - CCRoomAwardViewSize;
            [self.contentScrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull subview, NSUInteger idx, BOOL * _Nonnull stop) {
                subview.frame = CGRectMake(0, firstSubviewY, CCRoomAwardViewSize, CCRoomAwardViewSize);
                firstSubviewY -= scrollOffset;
            }];
            self.isInserting = NO;
        }
        
    } else {
        // 横向滑动
    }
}

- (void)handleVerticalInsertAnimationWithtView:(UIView *)insertView
{
    WEAK_SELF_DECLARED
    
    // 设置掉落动画起始位置
    insertView.frame = CGRectMake(0, -self.dropOffset, CCRoomAwardViewSize, CCRoomAwardViewSize);
    
    // 动画完成标志
    __block BOOL moveAnimationFinished = NO;
    __block BOOL dropAnimationFinished = NO;
    
    // 已展示的子视图
    NSMutableArray<UIView *> *displayedSubviews = [self.contentScrollView.subviews mutableCopy];
    [displayedSubviews removeObject:insertView];
    
    // 掉落最终位置
    CGFloat dropAnimatedEndY = 0;
    CGFloat lastViewTopMargin = displayedSubviews.lastObject.y;
    CGFloat scrollOffset = CCRoomAwardViewSize + self.itemSpacing;
    
    // 当前容器可以展示所有子视图，则已有视图不用改变布局
    if (self.contentScrollView.height >= self.contentScrollView.contentSize.height) {
        moveAnimationFinished = YES;
        dropAnimatedEndY = self.contentScrollView.height - (displayedSubviews.count + 1) * CCRoomAwardViewSize - displayedSubviews.count * self.itemSpacing;
    } else {
        
        // 新插入的视图只能展示部分，所以移动距离为其差值
        if (lastViewTopMargin > 0 && scrollOffset - lastViewTopMargin > 0) {
            scrollOffset = scrollOffset - lastViewTopMargin;
        }
        
        // 粗略计算需要移动动画的子视图
        NSInteger visibleCount = ceil(self.contentScrollView.height / CCRoomAwardViewSize);
        
        NSArray<UIView *> *animatedViews = nil;
        if (visibleCount >= displayedSubviews.count) {
            animatedViews = displayedSubviews;
        } else {
            animatedViews = [displayedSubviews subarrayWithRange:NSMakeRange(displayedSubviews.count - visibleCount, visibleCount)];
        }
        
        // 更新不需要动画的子视图的布局
        [displayedSubviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull subview, NSUInteger idx, BOOL * _Nonnull stop) {
            if (![animatedViews containsObject:subview]) {
                subview.y += scrollOffset;
            }
        }];
        
        // 更新需要动画的子视图位置
        [UIView animateWithDuration:0.25 animations:^{
            [animatedViews enumerateObjectsUsingBlock:^(UIView * _Nonnull subview, NSUInteger idx, BOOL * _Nonnull stop) {
                subview.y += scrollOffset;
            }];
        } completion:^(BOOL finished) {
            moveAnimationFinished = YES;
            if (dropAnimationFinished) {
                weakSelf.isInserting = NO;
            }
        }];
    }
    
    // 掉落动画
    insertView.makeY(dropAnimatedEndY).easeOutBounce.animate(0.5).animationCompletion = ^{
        dropAnimationFinished = YES;
        if (moveAnimationFinished) {
            weakSelf.isInserting = NO;
        }
    };
}

- (void)deleteAwardViewWithKey:(NSString *)key
{
    if (key == nil) {
        NSAssert(NO, @"");
        return;
    }
    
    UIView *targetView = [self.awardViewsMap objectForKey:key];
    if (targetView == nil) {
        CCLogInfo(@"%@", key);
        NSAssert(NO, @"");
        return;
    }
    
    // 确认删除位置及需要调整布局的视图
    NSInteger delIndex = [self.contentScrollView.subviews indexOfObject:targetView];
    if (NSNotFound == delIndex) {
        CCLogInfo(@"%@", key);
        return;
    }
    
    CGFloat scrollOffset = CCRoomAwardViewSize + self.itemSpacing;
    NSInteger numberAfterDeleted = self.contentScrollView.subviews.count - 1;
    CGFloat contentHeight = (numberAfterDeleted * CCRoomAwardViewSize) + (MAX(0, (numberAfterDeleted - 1)) * self.itemSpacing);
    self.contentScrollView.contentSize = CGSizeMake(CCRoomAwardViewSize, contentHeight);
    
    WEAK_SELF_DECLARED
    // 获取最后一个视图
    UIView *lastView = self.contentScrollView.subviews.firstObject;
    
    // 判断最后一个视图是否完全可见
    CGFloat invisibleOffset = CGRectGetMaxY(lastView.frame) - CGRectGetMaxY(self.contentScrollView.bounds);
    if (invisibleOffset > 0) {
        
        NSArray<UIView *> *headAnimatedViews = nil;
        NSArray<UIView *> *tailAnimatedViews = [self.contentScrollView.subviews subarrayWithRange:NSMakeRange(0, delIndex)];
        
        CGFloat headMoveOffset = 0;
        CGFloat tailMoveOffset = 0;
        // 部分可见时，动画往中间移动
        if (invisibleOffset < CCRoomAwardViewSize) {
            
            NSInteger headLoc = MIN(delIndex + 1, self.contentScrollView.subviews.count);
            NSInteger headLen = MAX(0, self.contentScrollView.subviews.count - headLoc);
            headAnimatedViews = [self.contentScrollView.subviews subarrayWithRange:NSMakeRange(headLoc, headLen)];
            
            headMoveOffset = scrollOffset - invisibleOffset;
            tailMoveOffset = invisibleOffset;
        } else {
            // 完全可见
            tailMoveOffset = scrollOffset;
        }
        
        [UIView animateWithDuration:0.4 animations:^{
            [headAnimatedViews enumerateObjectsUsingBlock:^(UIView * _Nonnull subview, NSUInteger idx, BOOL * _Nonnull stop) {
                subview.y += headMoveOffset;
            }];
            [tailAnimatedViews enumerateObjectsUsingBlock:^(UIView * _Nonnull subview, NSUInteger idx, BOOL * _Nonnull stop) {
                subview.y -= tailMoveOffset;
            }];
            targetView.alpha = 0;
        } completion:^(BOOL finished) {
            [targetView removeFromSuperview];
            targetView.alpha = 1;
            [weakSelf.awardViewsMap removeObjectForKey:key];
        }];
        
    } else {
        // 完全可见,往下移
        NSInteger headLoc = MIN(delIndex + 1, self.contentScrollView.subviews.count);
        NSInteger headLen = MAX(0, self.contentScrollView.subviews.count - headLoc);
        NSArray<UIView *> *animatedViews = [self.contentScrollView.subviews subarrayWithRange:NSMakeRange(headLoc, headLen)];
        
        [UIView animateWithDuration:0.4 animations:^{
            [animatedViews enumerateObjectsUsingBlock:^(UIView * _Nonnull subview, NSUInteger idx, BOOL * _Nonnull stop) {
                subview.y += scrollOffset;
            }];
            targetView.alpha = 0;
        } completion:^(BOOL finished) {
            [targetView removeFromSuperview];
            targetView.alpha = 1;
            [weakSelf.awardViewsMap removeObjectForKey:key];
        }];
    }
}

@end
