//
//  JPAspectMessage.m
//  JPAspect
//
//  Created by zzyong on 2019/5/5.
//  Copyright © 2019 zzyong. All rights reserved.
//

#import "JPAspectMessage.h"

@implementation JPAspectMessage

+ (instancetype)modelWithMessageDictionary:(NSDictionary *)messageDic
{
    JPAspectMessage *message = [[self alloc] init];
    
    if ([messageDic isKindOfClass:[NSDictionary class]]) {
        message.message = [messageDic objectForKey:@"message"];
        message.arguments = [messageDic objectForKey:@"arguments"];
        if (message.arguments.count > 0) {
            message.argumentCache = [NSMutableDictionary dictionaryWithCapacity:message.arguments.count];
        }
        message.messageType = [[messageDic objectForKey:@"messageType"] unsignedIntegerValue];
        message.invokeCondition = [messageDic objectForKey:@"invokeCondition"];
        message.localInstanceKey = [messageDic objectForKey:@"localInstanceKey"];
    }
    
    return message;
}

@end
