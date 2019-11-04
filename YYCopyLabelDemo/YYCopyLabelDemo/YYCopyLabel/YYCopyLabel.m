//
//  YYCopyLabel.m
//  YYCopyLabelDemo
//
//  Created by zzyong on 2019/11/4.
//  Copyright © 2019 zzyong. All rights reserved.
//

#import "YYCopyLabel.h"

@interface YYCopyLabel ()

@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGR;

@end

@implementation YYCopyLabel

- (void)setCopyEnabled:(BOOL)copyEnabled
{
    _copyEnabled = copyEnabled;
    
    self.userInteractionEnabled = copyEnabled;
    if (copyEnabled) {
        if (!self.longPressGR) {
            self.longPressGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
            [self addGestureRecognizer:self.longPressGR];
        }
    } else {
        if (self.longPressGR) {
            [self removeGestureRecognizer:self.longPressGR];
        }
    }
}

- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)longPressGR
{
    if (longPressGR.state == UIGestureRecognizerStateBegan) {
        UIMenuController *menuController = [UIMenuController sharedMenuController];
        UIMenuItem *copyItem = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copy:)];
        [menuController setMenuItems:@[copyItem]];
        [menuController setTargetRect:self.frame inView:self.superview];
        [menuController setMenuVisible:YES animated:YES];
    }
}

#pragma mark - UIMenuController

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

//自定义响应UIMenuItem Action，例如你可以过滤掉多余的系统自带功能（剪切，选择等），只保留复制功能。
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    return (action == @selector(copy:));
}

- (void)copy:(id)sender
{
    [[UIPasteboard generalPasteboard] setString:self.text];
}

@end
