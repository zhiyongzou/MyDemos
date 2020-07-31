//
//  HBHttpManager.h
//  HBullShares
//
//  Created by zzyong on 2020/7/31.
//  Copyright © 2020 zzyong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HBHttpManager : NSObject

+ (nullable NSURLSessionDataTask *)requestWithUrlString:(NSString *)URLString
                                             parameters:(nullable NSDictionary *)parameters
                                                success:(nullable void (^)(id _Nullable response))success
                                                failure:(nullable void (^)(NSError *error))failure;

+ (nullable NSURLSessionDataTask *)requestWithUrlString:(NSString *)URLString
                                             parameters:(nullable NSDictionary *)parameters
                                               progress:(nullable void (^)(NSProgress *downloadProgress))downloadProgress
                                                success:(nullable void (^)(id _Nullable response))success
                                                failure:(nullable void (^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
