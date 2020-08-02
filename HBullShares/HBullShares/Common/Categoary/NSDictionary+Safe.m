//
//  NSDictionary+Safe.m
//  HBullShares
//
//  Created by zzyong on 2020/8/2.
//  Copyright © 2020 zzyong. All rights reserved.
//

#import "NSDictionary+Safe.h"

@implementation NSDictionary (Safe)

- (nullable NSDictionary *)dictionaryForKey:(NSString *)key
{
    if (key == nil) {
        return nil;
    }
    
    NSDictionary *dic = [self objectForKey:key];
    if ([dic isKindOfClass:[NSDictionary class]]) {
        return dic;
    }
    
    return nil;
}

- (nullable NSArray *)arrayForKey:(NSString *)key
{
    if (key == nil) {
        return nil;
    }
    
    NSArray *array = [self objectForKey:key];
    if ([array isKindOfClass:[NSArray class]]) {
        return array;
    }
    
    return nil;
}

@end
