//
//  MyView.m
//  MyStaticLibA
//
//  Created by zzyong on 2020/5/20.
//  Copyright © 2020 zzyong. All rights reserved.
//

#import "MyView.h"

@implementation MyView

- (instancetype)init
{
    if (self = [super init]) {
        self.layer.contents = (__bridge id)([UIImage imageNamed:@"pk_guide_bule_progress"].CGImage);
    }
    
    return self;
}

@end
