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
    JPAspectMessage *aspectMessage = [[self alloc] init];
    
    if ([messageDic isKindOfClass:[NSDictionary class]]) {
        aspectMessage.message = [messageDic objectForKey:@"message"];
#ifdef DEBUG
        NSString *message = [aspectMessage.message stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (message && ![aspectMessage.message isEqualToString:message]) {
            NSAssert(NO, @"Message has whitespace character");
        }
#endif
        aspectMessage.arguments = [messageDic objectForKey:@"arguments"];
        aspectMessage.messageType = [[messageDic objectForKey:@"messageType"] unsignedIntegerValue];
        aspectMessage.invokeCondition = [messageDic objectForKey:@"invokeCondition"];
#ifdef DEBUG
        NSString *condition = [aspectMessage.invokeCondition[@"condition"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (condition && ![condition isEqualToString:aspectMessage.invokeCondition[@"condition"]]) {
            NSAssert(NO, @"Condition has whitespace character");
        }
#endif
        aspectMessage.localInstanceKey = [messageDic objectForKey:@"localInstanceKey"];
    }
    
    return aspectMessage;
}

@end
