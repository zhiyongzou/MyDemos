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
    NSCalendar *clendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitMinute | NSCalendarUnitHour | NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear;
    
    NSDateComponents *theDateComponents = [clendar components:unitFlags fromDate:theDate];
    NSDateComponents *nowComponents = [clendar components:unitFlags fromDate:[NSDate date]];

    NSString *format = nil;
    if ([theDateComponents year] != [nowComponents year]) { //不是今年
        format = @"yyyy-MM-dd";
    } else { //同一年
        if ([theDateComponents month] == [nowComponents month]) {   //同一月
            if ([theDateComponents day] == [nowComponents day]) {   //同一天
                format = @"今天 HH:mm";
            } else {
                format = @"MM-dd HH:mm";
            }
        } else {
            format = @"MM-dd HH:mm";
        }
    }

    static NSDateFormatter *dateFormatter = nil;
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
    }
    
    [dateFormatter setDateFormat:format];
    return [dateFormatter stringFromDate: theDate];
}

@end
