//
//  AspectProtocols.h
//  JPAspect
//
//  Created by zzyong on 2018/10/23.
//  Copyright © 2018 zzyong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// Opaque Aspect Token that allows to deregister the hook.
@protocol AspectTokenProtocol <NSObject>

/// Deregisters an aspect.
/// @return YES if deregistration is successful, otherwise NO.
- (BOOL)remove;

@end

/// The AspectInfo protocol is the first parameter of our block syntax.
@protocol AspectInfoProtocol <NSObject>

/// The instance that is currently hooked.
- (id)instance;

/// The original invocation of the hooked method.
- (NSInvocation *)originalInvocation;

/// All method arguments, boxed. This is lazily evaluated.
- (NSArray *)arguments;

@end

NS_ASSUME_NONNULL_END
