//
//  OCAspectInfo.m
//  JPAspect
//
//  Created by zzyong on 2018/10/23.
//  Copyright © 2018 zzyong. All rights reserved.
//

#import "OCAspectInfo.h"
#import "NSInvocation+OCAspects.h"

@implementation OCAspectInfo

@synthesize arguments = _arguments;

- (id)initWithInstance:(__unsafe_unretained id)instance invocation:(NSInvocation *)invocation
{
    NSCParameterAssert(instance);
    NSCParameterAssert(invocation);
    if (self = [super init]) {
        _instance = instance;
        _originalInvocation = invocation;
    }
    return self;
}

- (NSArray *)arguments
{
    // Lazily evaluate arguments, boxing is expensive.
    if (!_arguments) {
        _arguments = self.originalInvocation.aspects_arguments;
    }
    return _arguments;
}

@end
