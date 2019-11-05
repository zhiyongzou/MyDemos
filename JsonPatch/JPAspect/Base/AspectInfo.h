//
//  AspectInfo.h
//  JPAspect
//
//  Created by zzyong on 2018/10/23.
//  Copyright © 2018 zzyong. All rights reserved.
//

#import "AspectProtocols.h"

NS_ASSUME_NONNULL_BEGIN

@interface AspectInfo : NSObject <AspectInfoProtocol>

- (instancetype)initWithInstance:(__unsafe_unretained id)instance invocation:(NSInvocation *)invocation;

@property (nonatomic, unsafe_unretained, readonly) id instance;
@property (nonatomic, strong, readonly) NSArray *arguments;
@property (nonatomic, strong, readonly) NSInvocation *originalInvocation;

@end

NS_ASSUME_NONNULL_END
