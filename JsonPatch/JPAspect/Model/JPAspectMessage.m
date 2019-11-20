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
        message.parameters = [messageDic objectForKey:@"parameters"];
        if (message.parameters.count > 0) {
            message.aspectArgumentParameters = [NSMutableDictionary dictionaryWithCapacity:message.parameters.count];
        }
        message.messageType = [[messageDic objectForKey:@"messageType"] unsignedIntegerValue];
        message.invokeCondition = [messageDic objectForKey:@"invokeCondition"];
        message.localInstanceKey = [messageDic objectForKey:@"localInstanceKey"];
    }
    
    return message;
}

@end
