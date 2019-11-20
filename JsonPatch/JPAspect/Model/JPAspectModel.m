//
//  JPAspectModel.m
//  JPAspect
//
//  Created by zzyong on 2018/10/18.
//  Copyright © 2018 zzyong. All rights reserved.
//

#import "JPAspectModel.h"
#import "JPAspectArgument.h"
#import "JPAspectMessage.h"

@implementation JPAspectModel

+ (nullable instancetype)modelWithAspectDictionary:(NSDictionary *)dictionary
{
    JPAspectModel *aspectModel = nil;
    do {
        if (![dictionary isKindOfClass:[NSDictionary class]]) {
            NSAssert(0, @"[JPAspectModel] aspectDictionary class must be NSDictionary");
            break;
        }
        
        NSString *className = [dictionary objectForKey:@"className"];
        NSString *selName = [dictionary objectForKey:@"selName"];
        if (!className || !selName || ![className isKindOfClass:[NSString class]] || ![selName isKindOfClass:[NSString class]]) {
            break;
        }
        
        aspectModel = [[self alloc] init];
        aspectModel.className = className;
        aspectModel.selName = selName;
        aspectModel.hookType = [[dictionary objectForKey:@"hookType"] unsignedIntegerValue];
        aspectModel.argumentNames = [dictionary objectForKey:@"argumentNames"];
        
        NSArray<NSDictionary *> *customMessages = [dictionary objectForKey:@"customMessages"];
        if ([customMessages isKindOfClass:[NSArray class]] && customMessages.count > 0) {
            NSMutableArray<JPAspectMessage *> *messages = [NSMutableArray arrayWithCapacity:customMessages.count];
            
            [customMessages enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                [messages addObject:[JPAspectMessage modelWithMessageDictionary:obj]];
            }];
            
            aspectModel.customMessages = messages;
        }
        
    } while (0);
    
    return aspectModel;
}

@end
