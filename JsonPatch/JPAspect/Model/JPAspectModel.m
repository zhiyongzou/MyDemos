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

+ (nullable instancetype)modelWithAspectDictionary:(NSDictionary *)aspectDictionary
{
    JPAspectModel *aspectModel = nil;
    do {
        if (![aspectDictionary isKindOfClass:[NSDictionary class]]) {
            NSAssert(0, @"[JPAspectModel] aspectDictionary class must be NSDictionary");
            break;
        }
        
        NSString *className = [aspectDictionary objectForKey:@"className"];
        NSString *selName = [aspectDictionary objectForKey:@"selName"];
        if (!className || !selName || ![className isKindOfClass:[NSString class]] || ![selName isKindOfClass:[NSString class]]) {
            break;
        }
        
        aspectModel = [[JPAspectModel alloc] init];
        aspectModel.className = className;
        aspectModel.selName = selName;
        aspectModel.hookType = [[aspectDictionary objectForKey:@"hookType"] unsignedIntegerValue];
        aspectModel.parameterNames = [aspectDictionary objectForKey:@"parameterNames"];
        
        NSArray<NSDictionary *> *customInvokeMessages = [aspectDictionary objectForKey:@"customInvokeMessages"];
        if ([customInvokeMessages isKindOfClass:[NSArray class]] && customInvokeMessages.count > 0) {
            NSMutableArray<JPAspectMessage *> *messages = [NSMutableArray arrayWithCapacity:customInvokeMessages.count];
            
            [customInvokeMessages enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                JPAspectMessage *message = [JPAspectMessage modelWithMessageDictionary:obj];
                if (message) {
                    [messages addObject:message];
                }
            }];
            
            aspectModel.customInvokeMessages = messages;
        }
        
        
    } while (0);
    
    return aspectModel;
}

@end
