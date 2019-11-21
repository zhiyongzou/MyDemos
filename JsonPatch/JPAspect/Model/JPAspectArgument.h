//
//  JPAspectArgument.h
//  JPAspect
//
//  Created by zzyong on 2018/10/18.
//  Copyright © 2018 zzyong. All rights reserved.
//

#import "JPAspectTypes.h"

NS_ASSUME_NONNULL_BEGIN

@interface JPAspectArgument : NSObject

@property (nonatomic, assign) NSUInteger index;
@property (nonatomic, assign) JPArgumentType type;
@property (nonatomic, strong, nullable) id value;

+ (instancetype)modelWithArgumentDictionary:(NSDictionary *)argumentDic;

@end

NS_ASSUME_NONNULL_END
