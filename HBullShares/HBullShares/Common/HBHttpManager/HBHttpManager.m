//
//  HBHttpManager.m
//  HBullShares
//
//  Created by zzyong on 2020/7/31.
//  Copyright © 2020 zzyong. All rights reserved.
//

#import "HBHttpManager.h"
#import <AFNetworking.h>

@implementation HBHttpManager

+ (nullable NSURLSessionDataTask *)requestWithUrlString:(NSString *)URLString
                                             parameters:(nullable NSDictionary *)parameters
                                                success:(nullable void (^)(id _Nullable response))success
                                                failure:(nullable void (^)(NSError *error))failure
{
    return [self requestWithUrlString:URLString parameters:parameters progress:nil success:success failure:failure];
}

+ (nullable NSURLSessionDataTask *)requestWithUrlString:(NSString *)URLString
                                             parameters:(nullable NSDictionary *)parameters
                                               progress:(nullable void (^)(NSProgress *downloadProgress))downloadProgress
                                                success:(nullable void (^)(id _Nullable response))success
                                                failure:(nullable void (^)(NSError *error))failure
{
    if (URLString == nil) {
        NSAssert(NO, @"URLString is nil");
        return nil;
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSSet *acceptableContentTypes = manager.responseSerializer.acceptableContentTypes;
    acceptableContentTypes = [acceptableContentTypes setByAddingObjectsFromArray:@[@"application/javascript"]];
    [manager.responseSerializer setAcceptableContentTypes:acceptableContentTypes];
    
    return [manager GET:URLString parameters:parameters headers:nil progress:downloadProgress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
