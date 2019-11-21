//
//  JPAspect.h
//  JPAspect
//
//  Created by zzyong on 2018/10/18.
//  Copyright © 2018 zzyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JPAspectModel;

NS_ASSUME_NONNULL_BEGIN

@interface JPAspect : NSObject

/// 设置使用到的 OC 类
+ (void)setupAspectDefineClass:(NSArray<NSString *> *)classList;

+ (void)hookMethodWithAspectDictionary:(NSDictionary *)aspectDictionary;

@end

NS_ASSUME_NONNULL_END
