//
//  JPAspectInstance.h
//  JPAspect
//
//  Created by zzyong on 2019/5/10.
//  Copyright © 2019 zzyong. All rights reserved.
//

#import "JPAspectTypes.h"

NS_ASSUME_NONNULL_BEGIN

@interface JPAspectInstance : NSObject

@property (nonatomic, strong, nullable) id value;
@property (nonatomic, assign) JPArgumentType type;

@end

NS_ASSUME_NONNULL_END
