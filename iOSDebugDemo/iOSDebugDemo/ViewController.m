//
//  ViewController.m
//  iOSDebugDemo
//
//  Created by zzyong on 2020/4/26.
//  Copyright © 2020 zzyong. All rights reserved.
//

#import "ViewController.h"
#import "iOSDebugDemo-Swift.h"

@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self swiftErrorBreakpoint];
    [self autoLayoutError];
}

- (void)swiftErrorBreakpoint
{
    MyView *view = [[MyView alloc] init];
    [view throwRrrorAndReturnError:NULL];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self arrayException];
}

- (void)arrayException
{
    [@[] objectAtIndex:1];
}

- (void)autoLayoutError
{
    UIView *redView = [UIView new];
    redView.backgroundColor = [UIColor redColor];
    [self.view addSubview:redView];
    
    /**
      Create constraints explicitly.  Constraints are of the form "view1.attr1 = view2.attr2 * multiplier + constant"
      If your equation does not have a second view and attribute, use nil and NSLayoutAttributeNotAnAttribute.
      Use of this method is not recommended. Constraints should be created using anchor objects on views and layout guides.
      
     + (instancetype)constraintWithItem:(id)view1 attribute:(NSLayoutAttribute)attr1 relatedBy:(NSLayoutRelation)relation toItem:(nullable id)view2 attribute:(NSLayoutAttribute)attr2 multiplier:(CGFloat)multiplier constant:(CGFloat)c API_AVAILABLE(macos(10.7), ios(6.0), tvos(9.0));
     
     */
    
    // redView.right = self.view.right
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:redView
                                                             attribute:NSLayoutAttributeRight
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.view
                                                             attribute:NSLayoutAttributeRight
                                                            multiplier:1
                                                              constant:0];
    // width = 100
    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:redView
                                                             attribute:NSLayoutAttributeWidth
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:nil
                                                             attribute:NSLayoutAttributeNotAnAttribute
                                                            multiplier:0
                                                              constant:100];
    // height = 100
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:redView
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:0
                                                               constant:100];
    // redView.top = self.view.top
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:redView
                                                           attribute:NSLayoutAttributeTop
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:self.view
                                                           attribute:NSLayoutAttributeTop
                                                          multiplier:1
                                                            constant:0];
    
    [self.view addConstraints:@[right, top, width, height]];
}


@end
