//
//  NSDictionary+Safe.h
//  HBullShares
//
//  Created by zzyong on 2020/8/2.
//  Copyright © 2020 zzyong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (Safe)

- (nullable NSDictionary *)dictionaryForKey:(NSString *)key;

- (nullable NSArray *)arrayForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
