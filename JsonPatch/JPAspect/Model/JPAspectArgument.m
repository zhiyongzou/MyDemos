//
//  JPAspectArgument.m
//  JPAspect
//
//  Created by zzyong on 2018/10/18.
//  Copyright © 2018 zzyong. All rights reserved.
//

#import "JPAspectArgument.h"
#import <UIKit/UIGeometry.h>
#import <CoreGraphics/CoreGraphics.h>

NSUInteger const JPAspectMethodDefaultArgumentsCount = 2;

@implementation JPAspectArgument

+ (instancetype)modelWithArgumentDictionary:(NSDictionary *)argumentDic
{
    JPAspectArgument *aspectArgument = [[self alloc] init];
    
    aspectArgument.index = [[argumentDic objectForKey:@"index"] unsignedIntegerValue] + JPAspectMethodDefaultArgumentsCount;
    aspectArgument.type = [[argumentDic objectForKey:@"type"] unsignedIntegerValue];
    
    if (aspectArgument.type == JPArgumentTypeUnknown) {
        JPAspectLog(@"%@", @"[JPAspectArgument] Argument type is JPArgumentTypeUnknown");
        return aspectArgument;
    }
    
     if (aspectArgument.type == JPArgumentTypeClass) {
        
        aspectArgument.value = NSClassFromString([argumentDic objectForKey:@"value"]);
        
    } else if (aspectArgument.type == JPArgumentTypeCGRect) {
        
        NSArray *rectComponents = [[argumentDic objectForKey:@"value"] componentsSeparatedByString:@","];
        if (rectComponents.count == 4) {
            CGRect value = CGRectMake([rectComponents[0] doubleValue], [rectComponents[1] doubleValue], [rectComponents[2] doubleValue], [rectComponents[3] doubleValue]);
            aspectArgument.value = [NSValue valueWithCGRect:value];
        } else {
            JPAspectLog(@"[JPAspect] CGRect value:[%@] type is error", [argumentDic objectForKey:@"value"]);
        }
        
    } else if (aspectArgument.type == JPArgumentTypeCGPoint) {
        
        NSArray *pointComponents = [[argumentDic objectForKey:@"value"] componentsSeparatedByString:@","];
        if (pointComponents.count == 2) {
            CGPoint value = CGPointMake([pointComponents[0] doubleValue], [pointComponents[1] doubleValue]);
            aspectArgument.value = [NSValue valueWithCGPoint:value];
        } else {
            JPAspectLog(@"[JPAspect] CGPoint value:[%@] type is error", [argumentDic objectForKey:@"value"]);
        }
        
    } else if (aspectArgument.type == JPArgumentTypeCGSize) {
        
        NSArray *sizeComponents = [[argumentDic objectForKey:@"value"] componentsSeparatedByString:@","];
        if (sizeComponents.count == 2) {
            CGSize value = CGSizeMake([sizeComponents[0] doubleValue], [sizeComponents[1] doubleValue]);
            aspectArgument.value = [NSValue valueWithCGSize:value];
        } else {
            JPAspectLog(@"[JPAspect] CGSize value:[%@] type is error", [argumentDic objectForKey:@"value"]);
        }
        
    } else if (aspectArgument.type == JPArgumentTypeUIEdgeInsets) {
        
        NSArray *insetsComponents = [[argumentDic objectForKey:@"value"] componentsSeparatedByString:@","];
        if (insetsComponents.count == 4) {
            UIEdgeInsets insets = UIEdgeInsetsMake([insetsComponents[0] doubleValue], [insetsComponents[1] doubleValue], [insetsComponents[2] doubleValue], [insetsComponents[3] doubleValue]);
            aspectArgument.value = [NSValue valueWithUIEdgeInsets:insets];
        } else {
            JPAspectLog(@"[JPAspect] UIEdgeInsets value:[%@] type is error", [argumentDic objectForKey:@"value"]);
        }
        
    } else {
        aspectArgument.value = [argumentDic objectForKey:@"value"];
    }
    
    return aspectArgument;
}


@end
