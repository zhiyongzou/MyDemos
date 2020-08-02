//
//  NSString+Time.h
//  HBullShares
//
//  Created by zzyong on 2020/8/1.
//  Copyright © 2020 zzyong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Time)

+ (NSString *)timeLineStringByDate:(NSDate *)theDate;

@end

NS_ASSUME_NONNULL_END
