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
@property (nonatomic, strong, nullable) NSArray<NSString *> *parameterNames;
@property (nonatomic, assign) JPAspectHookType hookType;

@property (nonatomic, strong, nullable) NSArray<JPAspectMessage *> *customInvokeMessages;

+ (nullable instancetype)modelWithAspectDictionary:(NSDictionary *)aspectDictionary;

@end

NS_ASSUME_NONNULL_END
