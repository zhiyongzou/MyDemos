//
//  NSInvocation+Aspects.h
//  JPAspect
//
//  Created by zzyong on 2018/10/18.
//  Copyright © 2018 zzyong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSInvocation (Aspects)

- (NSArray *)aspects_arguments;

@end

NS_ASSUME_NONNULL_END
