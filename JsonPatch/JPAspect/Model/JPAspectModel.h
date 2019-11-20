//
//  JPAspectModel.h
//  JPAspect
//
//  Created by zzyong on 2018/10/18.
//  Copyright © 2018 zzyong. All rights reserved.
//

#import "JPAspectTypes.h"

@class JPAspectMessage;

NS_ASSUME_NONNULL_BEGIN

@interface JPAspectModel : NSObject

@property (nonatomic, strong) NSString *className;
@property (nonatomic, strong) NSString *selName;
/// 必须按照方法参数顺序
@property (nonatomic, strong, nullable) NSArray<NSString *> *argumentNames;
@property (nonatomic, assign) JPAspectHookType hookType;
/// 自定义方法
@property (nonatomic, strong, nullable) NSArray<JPAspectMessage *> *customMessages;

+ (nullable instancetype)modelWithAspectDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
