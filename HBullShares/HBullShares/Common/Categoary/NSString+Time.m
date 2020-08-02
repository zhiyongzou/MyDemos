//
//  NSString+Time.m
//  HBullShares
//
//  Created by zzyong on 2020/8/1.
//  Copyright © 2020 zzyong. All rights reserved.
//

#import "NSString+Time.h"

@implementation NSString (Time)

+ (NSString *)timeLineStringByDate:(NSDate *)theDate
{
    NSTimeInterval interval = fabs([theDate timeIntervalSinceNow]);
    
    if (interval < 60) { //一分钟内
        return @"刚刚";
    } else if (interval < (60 * 60)) { //一小时内
        return [NSString stringWithFormat:@"%ld分钟前", ((long)interval)/60];
    } else if (interval < (60 * 60 * 24)) {   //一天内
        return [NSString stringWithFormat:@"%ld小时前", ((long)interval)/(60 * 60)];
    } else if (interval < (60 * 60 * 24 * 30)) { // 一个月内
        return [NSString stringWithFormat:@"%ld天前", ((long)interval)/(60 * 60 * 24)];
    } else if (interval < (60 * 60 * 24 * 30 * 12)) { // 一年内
        return [NSString stringWithFormat:@"%ld个月前", ((long)interval)/(60 * 60 * 24 * 30)];
    } else {
        return [NSString stringWithFormat:@"%ld年前",((long)interval)/(60 * 60 * 24 * 30 * 12)];
    }
}

@end
