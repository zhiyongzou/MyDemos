//
//  JPAspect.m
//  JPAspect
//
//  Created by zzyong on 2018/10/18.
//  Copyright © 2018 zzyong. All rights reserved.
//

#import "Aspects.h"
#import "JPAspect.h"
#import <objc/runtime.h>
#import "JPAspectModel.h"
#import "JPAspectMessage.h"
#import "JPAspectArgument.h"
#import "JPAspectInstance.h"
#import <UIKit/UIGeometry.h>
#import <CoreGraphics/CoreGraphics.h>
#import "JPAspect+CustomInvokeInstead.h"

#define JPAspectBaseLogInfo(_aspectInfo) [NSString stringWithFormat:@"[%@ %@]", NSStringFromClass([_aspectInfo.instance class]), [NSStringFromSelector(_aspectInfo.originalInvocation.selector) substringFromIndex:9]]

/// Aspect Class List
static NSArray<NSString *> *JPAspectDefineClassList;
/// Super Alias Selector List
static NSMutableDictionary *JPSuperAliasSelectorList = nil;
/// Original method return value key
static NSString * const kAspectOriginalMethodReturnValueKey = @"kAspectOriginalMethodReturnValueKey";

@implementation JPAspect

+ (void)setupAspectDefineClassList:(NSArray<NSString *> *)classList
{
    JPAspectDefineClassList = classList;
}

+ (void)hookMethodWithAspectDictionary:(NSDictionary *)aspectDictionary
{
    [self hookMethodWithAspectModel:[JPAspectModel modelWithAspectDictionary:aspectDictionary]];
}

+ (void)hookMethodWithAspectModel:(JPAspectModel *)aspectModel
{
    if (!aspectModel) {
        NSAssert(0, @"[JPAspect] aspect model is nil");
        return;
    }
    
    if (JPAspectHookUnknown == aspectModel.hookType) {
        JPAspectLog(@"[JPAspect] hook type is unknown");
        NSAssert(NO, @"");
        return;
    }
    
    Class targetCls = NSClassFromString(aspectModel.className);
    if (targetCls == nil) {
        JPAspectLog(@"[JPAspect] Target class:[%@] is nil", aspectModel.className);
        NSAssert(NO, @"");
        return;
    }
    
    SEL targetSel = NSSelectorFromString(aspectModel.selName);
    if (targetSel == nil) {
        JPAspectLog(@"[JPAspect] Target selector:[%@] is nil", aspectModel.selName);
        NSAssert(NO, @"");
        return;
    }
    
    // Class method
    if ([targetCls respondsToSelector:targetSel]) {
        targetCls = objc_getMetaClass([aspectModel.className UTF8String]);
    }
    
    NSError *aspectError = nil;
    __weak typeof(self) weakSelf = self;
    [targetCls aspect_hookSelector:targetSel withOptions:AspectPositionInstead usingBlock:^(id<AspectInfoProtocol> aspectInfo) {
        [weakSelf handleHookSelectorWithAspectInfo:aspectInfo aspectModel:aspectModel];
    } error:&aspectError];
    
    if (aspectError) {
        JPAspectLog(@"[JPAspect] %@ %@ Hook error:%@", aspectModel.className, aspectModel.selName, aspectError);
        NSAssert(NO, @"");
    }
}

#pragma mark - Private

+ (void)handleHookSelectorWithAspectInfo:(id<AspectInfoProtocol>)aspectInfo aspectModel:(JPAspectModel *)aspectModel
{
    switch (aspectModel.hookType) {
        case JPAspectHookNullImp: {

            JPAspectLog(@"%@", [NSString stringWithFormat:@"%@ replace to empty IMP", JPAspectBaseLogInfo(aspectInfo)]);
        }
            break;
        case JPAspectHookCustomInvokeAfter:
        case JPAspectHookCustomInvokeBefore:
        case JPAspectHookCustomInvokeInstead: {
            
            [self handleAspectCustomInvokeWithAspectInfo:aspectInfo aspectModel:aspectModel];
        }
            break;
            
        default:
            JPAspectLog(@"[JPAspect] Aspect hook type is unknown");
            break;
    }
}

+ (void)setArgumentValue:(JPAspectArgument *)aspectArgument invocation:(NSInvocation *)invocation
{
    if (aspectArgument.index >= invocation.methodSignature.numberOfArguments) {
        JPAspectLog(@"%@", [NSString stringWithFormat:@"[JPAspect] Argument index(%zd) is out of bounds [0, %zd)", aspectArgument.index, invocation.methodSignature.numberOfArguments]);
        NSAssert(NO, @"");
        return;
    }
    
    // index 0 is self, index 1 is SEL by default
    if (aspectArgument.index < 2) {
        NSAssert(NO, @"");
        return;
    }
    
    if (aspectArgument.type == JPArgumentTypeUnknown) {
        JPAspectLog(@"%@", @"[JPAspect] Argument type is JPArgumentTypeUnknown");
        NSAssert(NO, @"");
        return;
    }
    
    if (aspectArgument.type == JPArgumentTypeObject) {
        
        id value = aspectArgument.value;
        [invocation setArgument:&value atIndex:aspectArgument.index];
        
    } else if (aspectArgument.type == JPArgumentTypeClass) {
        
        Class value = aspectArgument.value;
        [invocation setArgument:&value atIndex:aspectArgument.index];
        
    } else if (aspectArgument.type == JPArgumentTypeSEL) {
        
        SEL value = NSSelectorFromString(aspectArgument.value);
        [invocation setArgument:&value atIndex:aspectArgument.index];
        
    } else if (aspectArgument.type == JPArgumentTypeCGRect) {
        
        CGRect value = [aspectArgument.value CGRectValue];
        [invocation setArgument:&value atIndex:aspectArgument.index];
        
    } else if (aspectArgument.type == JPArgumentTypeUIEdgeInsets) {
        
        UIEdgeInsets value = [aspectArgument.value UIEdgeInsetsValue];
        [invocation setArgument:&value atIndex:aspectArgument.index];
        
    } else if (aspectArgument.type == JPArgumentTypeCGPoint) {
        
        CGPoint value = [aspectArgument.value CGPointValue];
        [invocation setArgument:&value atIndex:aspectArgument.index];
        
    } else if (aspectArgument.type == JPArgumentTypeCGSize) {
        
        CGSize value = [aspectArgument.value CGSizeValue];
        [invocation setArgument:&value atIndex:aspectArgument.index];
        
    } else if (aspectArgument.type == JPArgumentTypeInt) {
        
        int value = [aspectArgument.value intValue];
        [invocation setArgument:&value atIndex:aspectArgument.index];
        
    } else if (aspectArgument.type == JPArgumentTypeUnsignedInt) {
        
        unsigned int value = [aspectArgument.value unsignedIntValue];
        [invocation setArgument:&value atIndex:aspectArgument.index];
        
    } else if (aspectArgument.type == JPArgumentTypeShort) {
        
        short value = [aspectArgument.value shortValue];
        [invocation setArgument:&value atIndex:aspectArgument.index];
        
    } else if (aspectArgument.type == JPArgumentTypeUnsignedShort) {
        
        unsigned short value = [aspectArgument.value unsignedShortValue];
        [invocation setArgument:&value atIndex:aspectArgument.index];
        
    } else if (aspectArgument.type == JPArgumentTypeLong) {
        
        long value = [aspectArgument.value longValue];
        [invocation setArgument:&value atIndex:aspectArgument.index];
        
    } else if (aspectArgument.type == JPArgumentTypeUnsignedLong) {
        
        unsigned long value = [aspectArgument.value unsignedLongValue];
        [invocation setArgument:&value atIndex:aspectArgument.index];
        
    } else if (aspectArgument.type == JPArgumentTypeLongLong) {
        
        long long value = [aspectArgument.value longLongValue];
        [invocation setArgument:&value atIndex:aspectArgument.index];
        
    } else if (aspectArgument.type == JPArgumentTypeUnsignedLongLong) {
        
        unsigned long long value = [aspectArgument.value unsignedLongLongValue];
        [invocation setArgument:&value atIndex:aspectArgument.index];
        
    } else if (aspectArgument.type == JPArgumentTypeFloat) {
        
        float value = [aspectArgument.value floatValue];
        [invocation setArgument:&value atIndex:aspectArgument.index];
        
    } else if (aspectArgument.type == JPArgumentTypeDouble) {
        
        double value = [aspectArgument.value doubleValue];
        [invocation setArgument:&value atIndex:aspectArgument.index];
        
    } else if (aspectArgument.type == JPArgumentTypeBool) {
        
        BOOL value = [aspectArgument.value boolValue];
        [invocation setArgument:&value atIndex:aspectArgument.index];
        
    } else {
        JPAspectLog(@"%@", [NSString stringWithFormat:@"[JPAspect] Argument type:[%zd] is unknown", aspectArgument.type]);
    }
}

+ (nullable JPAspectArgument *)getArgumentWithInvocation:(NSInvocation *)invocation atIndex:(NSUInteger)index shouldSetValue:(BOOL)shouldSetValue
{
    index += JPAspectMethodDefaultArgumentsCount;
    
    if (index >= invocation.methodSignature.numberOfArguments) {
        JPAspectLog(@"%@", [NSString stringWithFormat:@"[JPAspect] Argument index(%zd) is out of bounds [0, %zd)", index, invocation.methodSignature.numberOfArguments]);
        NSAssert(NO, @"");
        return nil;
    }
    
    JPAspectArgument *aspectArgument = [[JPAspectArgument alloc] init];
    aspectArgument.index = index;
    
    const char *argType = [invocation.methodSignature getArgumentTypeAtIndex:index];
    
    if (strcmp(argType, @encode(id)) == 0) {
        
        if (shouldSetValue) {
            __unsafe_unretained id argumentValue = nil;
            [invocation getArgument:&argumentValue atIndex:index];
            aspectArgument.value = argumentValue;
        }
        aspectArgument.type = JPArgumentTypeObject;
        
    } else if (strcmp(argType, @encode(long)) == 0) {
        
        if (shouldSetValue) {
            long argumentValue = 0;
            [invocation getArgument:&argumentValue atIndex:index];
            aspectArgument.value = @(argumentValue);
        }
        aspectArgument.type = JPArgumentTypeLong;
        
    } else if (strcmp(argType, @encode(unsigned long)) == 0) {
        
        if (shouldSetValue) {
            unsigned long argumentValue = 0;
            [invocation getArgument:&argumentValue atIndex:index];
            aspectArgument.value = @(argumentValue);
        }
        aspectArgument.type = JPArgumentTypeUnsignedLong;
        
    } else if (strcmp(argType, @encode(long long)) == 0) {
        
        if (shouldSetValue) {
            long long argumentValue = 0;
            [invocation getArgument:&argumentValue atIndex:index];
            aspectArgument.value = @(argumentValue);
        }
        aspectArgument.type = JPArgumentTypeLongLong;
        
    } else if (strcmp(argType, @encode(unsigned long long)) == 0) {
        
        if (shouldSetValue) {
            unsigned long long argumentValue = 0;
            [invocation getArgument:&argumentValue atIndex:index];
            aspectArgument.value = @(argumentValue);
        }
        aspectArgument.type = JPArgumentTypeUnsignedLongLong;
        
    } else if (strcmp(argType, @encode(int)) == 0) {
        
        if (shouldSetValue) {
            int argumentValue = 0;
            [invocation getArgument:&argumentValue atIndex:index];
            aspectArgument.value = @(argumentValue);
        }
        aspectArgument.type = JPArgumentTypeInt;
        
    } else if (strcmp(argType, @encode(unsigned int)) == 0) {
        
        if (shouldSetValue) {
            unsigned int argumentValue = 0;
            [invocation getArgument:&argumentValue atIndex:index];
            aspectArgument.value = @(argumentValue);
        }
        aspectArgument.type = JPArgumentTypeUnsignedInt;
        
    } else if (strcmp(argType, @encode(short)) == 0) {
        
        if (shouldSetValue) {
            short argumentValue = 0;
            [invocation getArgument:&argumentValue atIndex:index];
            aspectArgument.value = @(argumentValue);
        }
        aspectArgument.type = JPArgumentTypeShort;
        
    } else if (strcmp(argType, @encode(unsigned short)) == 0) {
        
        if (shouldSetValue) {
            unsigned short argumentValue = 0;
            [invocation getArgument:&argumentValue atIndex:index];
            aspectArgument.value = @(argumentValue);
        }
        aspectArgument.type = JPArgumentTypeUnsignedShort;
        
    } else if (strcmp(argType, @encode(float)) == 0) {
        
        if (shouldSetValue) {
            float argumentValue = 0;
            [invocation getArgument:&argumentValue atIndex:index];
            aspectArgument.value = @(argumentValue);
        }
        aspectArgument.type = JPArgumentTypeFloat;
        
    } else if (strcmp(argType, @encode(BOOL)) == 0) {
        
        if (shouldSetValue) {
            BOOL argumentValue = 0;
            [invocation getArgument:&argumentValue atIndex:index];
            aspectArgument.value = @(argumentValue);
        }
        aspectArgument.type = JPArgumentTypeBool;
        
    } else if (strcmp(argType, @encode(double)) == 0) {
        
        if (shouldSetValue) {
            double argumentValue = 0;
            [invocation getArgument:&argumentValue atIndex:index];
            aspectArgument.value = @(argumentValue);
        }
        aspectArgument.type = JPArgumentTypeDouble;
        
    } else if (strcmp(argType, @encode(CGRect)) == 0) {
        
        if (shouldSetValue) {
            CGRect argumentValue;
            [invocation getArgument:&argumentValue atIndex:index];
            aspectArgument.value = [NSValue valueWithCGRect:argumentValue];
        }
        aspectArgument.type = JPArgumentTypeCGRect;
        
    } else if (strcmp(argType, @encode(UIEdgeInsets)) == 0) {
        
        if (shouldSetValue) {
            UIEdgeInsets argumentValue;
            [invocation getArgument:&argumentValue atIndex:index];
            aspectArgument.value = [NSValue valueWithUIEdgeInsets:argumentValue];
        }
        aspectArgument.type = JPArgumentTypeUIEdgeInsets;
        
    } else if (strcmp(argType, @encode(CGSize)) == 0) {
        
        if (shouldSetValue) {
            CGSize argumentValue;
            [invocation getArgument:&argumentValue atIndex:index];
            aspectArgument.value = [NSValue valueWithCGSize:argumentValue];
        }
        aspectArgument.type = JPArgumentTypeCGSize;
        
    } else if (strcmp(argType, @encode(CGPoint)) == 0) {
        
        if (shouldSetValue) {
            CGPoint argumentValue;
            [invocation getArgument:&argumentValue atIndex:index];
            aspectArgument.value = [NSValue valueWithCGPoint:argumentValue];
        }
        aspectArgument.type = JPArgumentTypeCGPoint;
        
    } else if (strcmp(argType, @encode(SEL)) == 0) {
        
        if (shouldSetValue) {
            SEL argumentValue;
            [invocation getArgument:&argumentValue atIndex:index];
            aspectArgument.value = NSStringFromSelector(argumentValue);
        }
        aspectArgument.type = JPArgumentTypeSEL;
        
    } else if (strcmp(argType, @encode(Class)) == 0) {
        
        if (shouldSetValue) {
            Class argumentValue;
            [invocation getArgument:&argumentValue atIndex:index];
            aspectArgument.value = argumentValue;
        }
        aspectArgument.type = JPArgumentTypeClass;
        
    } else {
        aspectArgument.type = JPArgumentTypeUnknown;
    }
    
    return aspectArgument;
}

+ (JPAspectInstance *)invokeMethodWithTarget:(id)target
                                     selName:(NSString *)selName
                               isClassMethod:(BOOL)isClassMethod
                                   arguments:(NSArray<JPAspectArgument *> *)arguments
{
    JPAspectInstance *instance = [[JPAspectInstance alloc] init];;
    if (!selName) {
        return instance;
    }
    
    SEL selector = sel_registerName([selName UTF8String]);
    
    NSMethodSignature *signature = nil;
    
    if (isClassMethod) {
        
        signature = [[target class] methodSignatureForSelector:selector];
    } else {
        
        signature = [[target class] instanceMethodSignatureForSelector:selector];
    }
    
    if (!signature) {
        JPAspectLog(@"[JPAspect] Target:[%@] method signature must not be nil. selName:%@", target, selName);
        return instance;
    }
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = target;
    invocation.selector = selector;
    
    for (JPAspectArgument *argument in arguments) {
        [self setArgumentValue:argument invocation:invocation];
    }
    
    [invocation invoke];
    
    const char *methodReturnType = signature.methodReturnType;
    if (strcmp(methodReturnType, @encode(id)) == 0) {
        
        if ([selName isEqualToString:@"alloc"])  {
            
            instance.value = [[target class] alloc];
            
        } else if ([selName isEqualToString:@"new"]) {
            
            instance.value = [[target class] new];
            
        } else if ([selName isEqualToString:@"copy"]) {
            
            instance.value = [target copy];
            
        } else if ([selName isEqualToString:@"mutableCopy"]) {
            
            instance.value = [target mutableCopy];
            
        } else {
            void *result;
            [invocation getReturnValue:&result];
            instance.value = (__bridge id)result;
        }
        instance.type = JPArgumentTypeObject;
        
    } else if (strcmp(methodReturnType, @encode(BOOL)) == 0) {
        
        BOOL result = NO;
        [invocation getReturnValue:&result];
        instance.value = @(result);
        instance.type = JPArgumentTypeBool;
        
    } else if (strcmp(methodReturnType, @encode(int)) == 0) {
        
        int result = 0;
        [invocation getReturnValue:&result];
        instance.value = @(result);
        instance.type = JPArgumentTypeInt;
        
    } else if (strcmp(methodReturnType, @encode(long)) == 0) {
        
        NSInteger result = 0;
        [invocation getReturnValue:&result];
        instance.value = @(result);
        instance.type = JPArgumentTypeLong;
        
    } else if (strcmp(methodReturnType, @encode(unsigned long)) == 0) {
        
        NSUInteger result = 0;
        [invocation getReturnValue:&result];
        instance.value = @(result);
        instance.type = JPArgumentTypeUnsignedLong;
        
    } else if (strcmp(methodReturnType, @encode(double)) == 0) {
        
        CGFloat result = 0;
        [invocation getReturnValue:&result];
        instance.value = @(result);
        instance.type = JPArgumentTypeDouble;
        
    } else if (strcmp(methodReturnType, @encode(CGSize)) == 0) {
        
        CGSize result;
        [invocation getReturnValue:&result];
        instance.value = [NSValue valueWithCGSize:result];
        instance.type = JPArgumentTypeCGSize;
        
    } else if (strcmp(methodReturnType, @encode(CGPoint)) == 0) {
        
        CGPoint result;
        [invocation getReturnValue:&result];
        instance.value = [NSValue valueWithCGPoint:result];
        instance.type = JPArgumentTypeCGPoint;
        
    } else if (strcmp(methodReturnType, @encode(CGRect)) == 0) {
        
        CGRect result;
        [invocation getReturnValue:&result];
        instance.value = [NSValue valueWithCGRect:result];
        instance.type = JPArgumentTypeCGRect;
    } else if (strcmp(methodReturnType, @encode(UIEdgeInsets)) == 0) {
        
        UIEdgeInsets result;
        [invocation getReturnValue:&result];
        instance.value = [NSValue valueWithUIEdgeInsets:result];
        instance.type = JPArgumentTypeUIEdgeInsets;
    } else if (strcmp(methodReturnType, @encode(Class)) == 0) {
        
        Class result;
        [invocation getReturnValue:&result];
        instance.value = result;
        instance.type = JPArgumentTypeClass;
    }
    
    invocation.target = nil;
    
    return instance;
}

+ (id)aspectInstanceValueWithType:(JPArgumentType)type contentString:(NSString *)contentString localVariables:(NSMutableDictionary<NSString *, JPAspectInstance *> *)localVariables
{
    id instance = nil;
    
    if (type == JPArgumentTypeUnknown) {
        return instance;
    }
    
    if (type == JPArgumentTypeObject) {
        
        instance = [[localVariables objectForKey:contentString] value];
        if (instance == nil) {
            instance = contentString;
        }
    } else if (type == JPArgumentTypeClass) {
        
        instance = NSClassFromString(contentString);
        
    } else if (type == JPArgumentTypeSEL) {
        
        instance = contentString;
        
    } else if (type == JPArgumentTypeCGRect) {
        
        NSArray *rectComponents = [contentString componentsSeparatedByString:@","];
        if (rectComponents.count == 4) {
            CGRect rect = CGRectMake([rectComponents[0] doubleValue], [rectComponents[1] doubleValue], [rectComponents[2] doubleValue], [rectComponents[3] doubleValue]);
            instance = [NSValue valueWithCGRect:rect];
        } else {
            instance = [NSValue valueWithCGRect:CGRectZero];
        }
        
    } else if (type == JPArgumentTypeUIEdgeInsets) {
        
        NSArray *insetsComponents = [contentString componentsSeparatedByString:@","];
        if (insetsComponents.count == 4) {
            UIEdgeInsets insets = UIEdgeInsetsMake([insetsComponents[0] doubleValue], [insetsComponents[1] doubleValue], [insetsComponents[2] doubleValue], [insetsComponents[3] doubleValue]);
            instance = [NSValue valueWithUIEdgeInsets:insets];
        } else {
            instance = [NSValue valueWithUIEdgeInsets:UIEdgeInsetsZero];
        }
        
    } else if (type == JPArgumentTypeCGSize) {
        
        NSArray *sizeComponents = [contentString componentsSeparatedByString:@","];
        if (sizeComponents.count == 2) {
            CGSize size = CGSizeMake([sizeComponents[0] doubleValue], [sizeComponents[1] doubleValue]);
            instance = [NSValue valueWithCGSize:size];
        } else {
            instance = [NSValue valueWithCGSize:CGSizeZero];
        }
        
    } else if (type == JPArgumentTypeCGPoint) {
        
        NSArray *pointComponents = [contentString componentsSeparatedByString:@","];
        if (pointComponents.count == 2) {
            CGPoint point = CGPointMake([pointComponents[0] doubleValue], [pointComponents[1] doubleValue]);
            instance = [NSValue valueWithCGPoint:point];
        } else {
            instance = [NSValue valueWithCGPoint:CGPointZero];
        }
    } else if (type == JPArgumentTypeInt) {
        
        instance = @([contentString intValue]);
        
    } else if (type == JPArgumentTypeLong) {
        
        instance = @([contentString integerValue]);
        
    } else if (type == JPArgumentTypeUnsignedLong) {
        
        instance = @([contentString doubleValue]);
        
    } else if (type == JPArgumentTypeLongLong) {
        
        instance = @([contentString longLongValue]);
        
    } else if (type == JPArgumentTypeFloat) {
        
        instance = @([contentString floatValue]);
        
    } else if (type == JPArgumentTypeDouble) {
        
        instance = @([contentString doubleValue]);
        
    } else if (type == JPArgumentTypeBool) {
        
        instance = @([contentString boolValue]);
        
    } else {
        JPAspectLog(@"%@", [NSString stringWithFormat:@"[JPAspect] Argument type:[%zd] is unsupport", type]);
    }
    
    return instance;
}

#pragma mark - JPAspectHookCustomInvoke

+ (void)handleAspectCustomInvokeWithAspectInfo:(id<AspectInfoProtocol>)aspectInfo aspectModel:(JPAspectModel *)aspectModel
{
    if (aspectModel.hookType == JPAspectHookCustomInvokeAfter) {
        [aspectInfo.originalInvocation invoke];
    }
    
    NSMutableDictionary<NSString *, JPAspectInstance *> *localVariables = [NSMutableDictionary dictionary];
    BOOL shouldReturn = NO;
    BOOL shouldInvoke = YES;
    
    for (JPAspectMessage *message in aspectModel.customInvokeMessages) {
        
        shouldInvoke = YES;
        if (message.invokeCondition != nil) {
            if (message.invokeCondition[@"conditionKey"]) {
                NSNumber *conditionCache = [[localVariables objectForKey:message.invokeCondition[@"conditionKey"]] value];
                if (conditionCache != nil) {
                    shouldInvoke = [conditionCache boolValue];
                } else {
                    shouldInvoke = [self shouldInvokedMessage:message aspectModel:aspectModel localVariables:localVariables aspectInfo:aspectInfo];
                    JPAspectInstance *instanceCondition = [[JPAspectInstance alloc] init];
                    instanceCondition.type = JPArgumentTypeBool;
                    instanceCondition.value = @(shouldInvoke);
                    [localVariables setObject:instanceCondition forKey:message.invokeCondition[@"conditionKey"]];
                }
                
            } else {
                shouldInvoke = [self shouldInvokedMessage:message aspectModel:aspectModel localVariables:localVariables aspectInfo:aspectInfo];
            }
        }
        
        // Only create condition instance
        if (message.message == nil) {
            continue;
        }
        
        if (shouldInvoke) {
            if (message.messageType == JPAspectMessageTypeReturn) {
                
                [self invokeReturnMessage:message aspectModel:aspectModel localVariables:localVariables aspectInfo:aspectInfo];
                shouldReturn = YES;
                JPAspectLog(@"[JPAspect] Message:[%@ %@] has been return success", aspectModel.className, aspectModel.selName);
                break;
                
            } else if (message.messageType == JPAspectMessageTypeAssign) {
                
                [self invokeAssignMessage:message aspectModel:aspectModel localVariables:localVariables aspectInfo:aspectInfo];
                
            } else {
                JPAspectInstance *localInstance = [self invokeCustomMessage:message aspectModel:aspectModel aspectInfo:aspectInfo localVariables:[localVariables copy]];
                if (message.localInstanceKey.length > 0) {
                    if (localInstance && localInstance.type != JPArgumentTypeUnknown) {
                        [localVariables setObject:localInstance forKey:message.localInstanceKey];
                        JPAspectLog(@"[JPAspect] Message:[%@] invoke success", message.message);
                    } else {
                        JPAspectLog(@"[JPAspect] Message:[%@] return value is nil", message.message);
                    }
                } else {
                    JPAspectLog(@"[JPAspect] Message:[%@] invoke success", message.message);
                }
            }
        }
    }
    
    if (shouldReturn == NO && aspectModel.hookType == JPAspectHookCustomInvokeBefore) {
        [aspectInfo.originalInvocation invoke];
        
    } else  if (shouldReturn || aspectModel.hookType == JPAspectHookCustomInvokeInstead) {
        JPAspectInstance *returnInstance = [localVariables objectForKey:kAspectOriginalMethodReturnValueKey];
        if (returnInstance) {
            id target = object_isClass(aspectInfo.originalInvocation.target) ? [JPAspect class] : [[JPAspect alloc] init];
            aspectInfo.originalInvocation.target = target;
            if (returnInstance.type == JPArgumentTypeObject) {
                
                aspectInfo.originalInvocation.selector = @selector(returnObject);
                [aspectInfo.originalInvocation invoke];
                id expectValue = returnInstance.value;
                [aspectInfo.originalInvocation setReturnValue:&expectValue];
                
            } else if (returnInstance.type == JPArgumentTypeCGRect) {
                
                aspectInfo.originalInvocation.selector = @selector(returnRect);
                [aspectInfo.originalInvocation invoke];
                CGRect expectValue = [(NSValue *)returnInstance.value CGRectValue];
                [aspectInfo.originalInvocation setReturnValue:&expectValue];
                
            } else if (returnInstance.type == JPArgumentTypeUIEdgeInsets) {
                
                aspectInfo.originalInvocation.selector = @selector(returnEdgeInsets);
                [aspectInfo.originalInvocation invoke];
                UIEdgeInsets expectValue = [(NSValue *)returnInstance.value UIEdgeInsetsValue];
                [aspectInfo.originalInvocation setReturnValue:&expectValue];
                
            } else if (returnInstance.type == JPArgumentTypeCGSize) {
                
                aspectInfo.originalInvocation.selector = @selector(returnSize);
                [aspectInfo.originalInvocation invoke];
                CGSize expectValue = [(NSValue *)returnInstance.value CGSizeValue];
                [aspectInfo.originalInvocation setReturnValue:&expectValue];
                
            } else if (returnInstance.type == JPArgumentTypeCGPoint) {
                
                aspectInfo.originalInvocation.selector = @selector(returnPoint);
                [aspectInfo.originalInvocation invoke];
                CGPoint expectValue = [(NSValue *)returnInstance.value CGPointValue];
                [aspectInfo.originalInvocation setReturnValue:&expectValue];
                
            } else if (returnInstance.type == JPArgumentTypeLong) {
                
                aspectInfo.originalInvocation.selector = @selector(returnLong);
                [aspectInfo.originalInvocation invoke];
                long expectValue = [(NSNumber *)returnInstance.value longValue];
                [aspectInfo.originalInvocation setReturnValue:&expectValue];
                
            } else if (returnInstance.type == JPArgumentTypeDouble) {
                
                aspectInfo.originalInvocation.selector = @selector(returnDouble);
                [aspectInfo.originalInvocation invoke];
                double expectValue = [(NSNumber *)returnInstance.value doubleValue];
                [aspectInfo.originalInvocation setReturnValue:&expectValue];
                
            } else if (returnInstance.type == JPArgumentTypeUnsignedLong) {
                
                aspectInfo.originalInvocation.selector = @selector(returnUnsignedLong);
                [aspectInfo.originalInvocation invoke];
                unsigned long expectValue = [(NSNumber *)returnInstance.value unsignedLongValue];
                [aspectInfo.originalInvocation setReturnValue:&expectValue];
                
            } else if (returnInstance.type == JPArgumentTypeBool) {
                
                aspectInfo.originalInvocation.selector = @selector(returnBool);
                [aspectInfo.originalInvocation invoke];
                BOOL expectValue = [(NSNumber *)returnInstance.value boolValue];
                [aspectInfo.originalInvocation setReturnValue:&expectValue];
                
            }
            aspectInfo.originalInvocation.target = nil;
            JPAspectLog(@"[JPAspect] [%@ %@] return type:[%zd] value: %@", aspectModel.className, aspectModel.selName, returnInstance.type, returnInstance.value);
        }
    }
}

+ (BOOL)shouldInvokedMessage:(JPAspectMessage *)message
                 aspectModel:(JPAspectModel *)aspectModel
              localVariables:(NSMutableDictionary<NSString *, JPAspectInstance *> *)localVariables
                  aspectInfo:(id<AspectInfoProtocol>)aspectInfo
{
    BOOL shouldInvoke = NO;
    
    do {
        
        NSString *operator = [message.invokeCondition objectForKey:@"operator"];
        
        if (operator == nil) {
            NSString *errorMsg = @"[JPAspect] Invoke condition operator must not be nil";
            JPAspectLog(@"%@", errorMsg);
            NSAssert(NO, errorMsg);
            break;
        }
        
        NSArray *conditionComponents = [message.invokeCondition[@"condition"] componentsSeparatedByString:operator];
        
        if (conditionComponents.count != 2) {
            NSString *errorMsg = [NSString stringWithFormat:@"[JPAspect] Condition:[%@] components which separated by [%@] must equal to 2", message.invokeCondition[@"condition"], operator];
            JPAspectLog(@"%@", errorMsg);
            NSAssert(NO, errorMsg);
            break;
        }
        
        if ([operator isEqualToString:@">"]  ||
            [operator isEqualToString:@">="] ||
            [operator isEqualToString:@"<"]  ||
            [operator isEqualToString:@"<="] ||
            [operator isEqualToString:@"||"] ||
            [operator isEqualToString:@"&&"]) {
            
            NSNumber *target_1 = [[localVariables objectForKey:conditionComponents.firstObject] value];
            if (target_1 == nil) {
                if ([aspectModel.parameterNames containsObject:conditionComponents.firstObject]) {
                    JPAspectArgument *argument = [self getArgumentWithInvocation:aspectInfo.originalInvocation
                                                                         atIndex:[aspectModel.parameterNames indexOfObject:conditionComponents.firstObject]
                                                                  shouldSetValue:YES];
                    target_1 = argument.value;
                } else {
                    target_1 = @([conditionComponents.firstObject doubleValue]);
                }
            }
            
            NSNumber *target_2 = [[localVariables objectForKey:conditionComponents.lastObject] value];
            if (target_2 == nil) {
                if ([aspectModel.parameterNames containsObject:conditionComponents.lastObject]) {
                    JPAspectArgument *argument = [self getArgumentWithInvocation:aspectInfo.originalInvocation
                                                                         atIndex:[aspectModel.parameterNames indexOfObject:conditionComponents.lastObject]
                                                                  shouldSetValue:YES];
                    target_2 = argument.value;
                } else {
                    target_2 = @([conditionComponents.lastObject doubleValue]);
                }
            }
            
            if ([operator isEqualToString:@">"] && NSOrderedDescending == [target_1 compare:target_2]) {
                shouldInvoke = YES;
                break;
            }
            
            if ([operator isEqualToString:@">="] && (NSOrderedDescending == [target_1 compare:target_2] || NSOrderedSame == [target_1 compare:target_2])) {
                shouldInvoke = YES;
                break;
            }
            
            if ([operator isEqualToString:@"<"] && NSOrderedAscending == [target_1 compare:target_2]) {
                shouldInvoke = YES;
                break;
            }
            
            if ([operator isEqualToString:@"<="] &&( NSOrderedAscending == [target_1 compare:target_2] || NSOrderedSame == [target_1 compare:target_2])) {
                shouldInvoke = YES;
                break;
            }
            
            if ([operator isEqualToString:@"||"]) {
                shouldInvoke = target_1.boolValue || target_2.boolValue;
                break;
            }
            
            if ([operator isEqualToString:@"&&"]) {
                shouldInvoke = target_1.boolValue && target_2.boolValue;
                break;
            }
            
        } else if ([operator isEqualToString:@"=="]) {
            
            if ([conditionComponents.lastObject isEqualToString:@"nil"]) {
                
                id target_1 = [[localVariables objectForKey:conditionComponents.firstObject] value];
                
                if (target_1 == nil && [aspectModel.parameterNames containsObject:conditionComponents.firstObject]) {
                    JPAspectArgument *argument = [self getArgumentWithInvocation:aspectInfo.originalInvocation
                                                                         atIndex:[aspectModel.parameterNames indexOfObject:conditionComponents.firstObject]
                                                                  shouldSetValue:YES];
                    target_1 = argument.value;
                }
                
                if (target_1 == nil) {
                    shouldInvoke = YES;
                }
            } else {
                NSNumber *target_1 = [[localVariables objectForKey:conditionComponents.firstObject] value];
                if (target_1 == nil) {
                    if ([aspectModel.parameterNames containsObject:conditionComponents.firstObject]) {
                        JPAspectArgument *argument = [self getArgumentWithInvocation:aspectInfo.originalInvocation
                                                                             atIndex:[aspectModel.parameterNames indexOfObject:conditionComponents.firstObject]
                                                                      shouldSetValue:YES];
                        target_1 = argument.value;
                    } else {
                        target_1 = @([conditionComponents.firstObject doubleValue]);
                    }
                }
                
                NSNumber *target_2 = [[localVariables objectForKey:conditionComponents.lastObject] value];
                if (target_2 == nil) {
                    if ([aspectModel.parameterNames containsObject:conditionComponents.lastObject]) {
                        JPAspectArgument *argument = [self getArgumentWithInvocation:aspectInfo.originalInvocation
                                                                             atIndex:[aspectModel.parameterNames indexOfObject:conditionComponents.lastObject]
                                                                      shouldSetValue:YES];
                        target_2 = argument.value;
                    } else {
                        target_2 = @([conditionComponents.lastObject doubleValue]);
                    }
                }
                
                if (NSOrderedSame == [target_1 compare:target_2]) {
                    shouldInvoke = YES;
                }
            }
            
        } else if ([operator isEqualToString:@"!="]) {
            NSNumber *target_1 = [[localVariables objectForKey:conditionComponents.firstObject] value];
            if (target_1 == nil) {
                if ([aspectModel.parameterNames containsObject:conditionComponents.firstObject]) {
                    JPAspectArgument *argument = [self getArgumentWithInvocation:aspectInfo.originalInvocation
                                                                         atIndex:[aspectModel.parameterNames indexOfObject:conditionComponents.firstObject]
                                                                  shouldSetValue:YES];
                    target_1 = argument.value;
                } else {
                    target_1 = @([conditionComponents.firstObject doubleValue]);
                }
            }
            
            NSNumber *target_2 = [[localVariables objectForKey:conditionComponents.lastObject] value];
            if (target_2 == nil) {
                if ([aspectModel.parameterNames containsObject:conditionComponents.lastObject]) {
                    JPAspectArgument *argument = [self getArgumentWithInvocation:aspectInfo.originalInvocation
                                                                         atIndex:[aspectModel.parameterNames indexOfObject:conditionComponents.lastObject]
                                                                  shouldSetValue:YES];
                    target_2 = argument.value;
                } else {
                    target_2 = @([conditionComponents.lastObject doubleValue]);
                }
            }
            
            if (NSOrderedSame != [target_1 compare:target_2]) {
                shouldInvoke = YES;
            }
        } else {
            NSString *errorMsg = [NSString stringWithFormat:@"[JPAspect] Message:[%@] operator:[%@] type is unknown", message.message, operator];
            JPAspectLog(@"%@", errorMsg);
            NSAssert(NO, errorMsg);
        }
        
    } while (0);
    
    return shouldInvoke;
}

+ (void)invokeAssignMessage:(JPAspectMessage *)message
                aspectModel:(JPAspectModel *)aspectModel
             localVariables:(NSMutableDictionary<NSString *, JPAspectInstance *> *)localVariables
                 aspectInfo:(id<AspectInfoProtocol>)aspectInfo
{
    NSArray *msgComponents = [message.message componentsSeparatedByString:@"="];
    
    if (msgComponents.count != 2) {
        NSString *errorMsg = [NSString stringWithFormat:@"[JPAspect] Message:[%@] components which separated by [=] must equal to 2", message.message];
        JPAspectLog(@"%@", errorMsg);
        NSAssert(NO, errorMsg);
        return;
    }
    
    NSArray *instanceValues = [msgComponents.lastObject componentsSeparatedByString:@":"];
    if (instanceValues.count != 2) {
        NSString *errorMsg = [NSString stringWithFormat:@"[JPAspect] InstanceValue:[%@] components which separated by [:] must equal to 2", msgComponents.lastObject];
        JPAspectLog(@"%@", errorMsg);
        NSAssert(NO, errorMsg);
        return;
    }
    
    if ([aspectModel.parameterNames containsObject:msgComponents.firstObject]) {
        
        NSUInteger argumentIndex = [aspectModel.parameterNames indexOfObject:msgComponents.firstObject]  + JPAspectMethodDefaultArgumentsCount;
        JPAspectArgument *argument = [[JPAspectArgument alloc] init];
        argument.type = [instanceValues.firstObject integerValue];
        argument.index = argumentIndex;
        argument.value = [JPAspect aspectInstanceValueWithType:argument.type contentString:instanceValues.lastObject localVariables:localVariables];
        [JPAspect setArgumentValue:argument invocation:aspectInfo.originalInvocation];
        
    } else {
        
        JPAspectInstance *instance = [localVariables objectForKey:msgComponents.firstObject];
        
        if (instance == nil) {
            instance = [[JPAspectInstance alloc] init];
            instance.type = [instanceValues.firstObject integerValue];
            [localVariables setObject:instance forKey:msgComponents.firstObject];
        }
        
        instance.value = [JPAspect aspectInstanceValueWithType:instance.type contentString:instanceValues.lastObject localVariables:localVariables];
    }
}

+ (void)invokeReturnMessage:(JPAspectMessage *)message
                aspectModel:(JPAspectModel *)aspectModel
             localVariables:(NSMutableDictionary<NSString *, JPAspectInstance *> *)localVariables
                 aspectInfo:(id<AspectInfoProtocol>)aspectInfo
{
    if ([message.message isEqualToString:@"return"]) {
        
    } else if ([message.message hasPrefix:@"return="]) {
        
        NSString *returnValue = [message.message substringFromIndex:7];
        NSArray *returnValues = [returnValue componentsSeparatedByString:@":"];
        if (returnValues.count != 2) {
            NSString *errorMsg = [NSString stringWithFormat:@"[JPAspect] ReturnValue:[%@] components which separated by [:] must equal to 2", returnValue];
            JPAspectLog(@"%@", errorMsg);
            NSAssert(NO, errorMsg);
            return;
        }
        
        JPAspectInstance *instance = [localVariables objectForKey:kAspectOriginalMethodReturnValueKey];
        if (instance == nil) {
            instance = [[JPAspectInstance alloc] init];
            instance.type = [returnValues.firstObject integerValue];
            [localVariables setObject:instance forKey:kAspectOriginalMethodReturnValueKey];
        }
        
        instance.value = [JPAspect aspectInstanceValueWithType:instance.type contentString:returnValues.lastObject localVariables:localVariables];
        
    } else {
        NSString *errorMsg = [NSString stringWithFormat:@"[JPAspect] Return Message:[%@] format is error", message.message];
        JPAspectLog(@"%@", errorMsg);
        NSAssert(NO, errorMsg);
    }
}

+ (JPAspectInstance *)invokeCustomMessage:(JPAspectMessage *)message
                              aspectModel:(JPAspectModel *)aspectModel
                               aspectInfo:(id<AspectInfoProtocol>)aspectInfo
                           localVariables:(NSDictionary<NSString *, JPAspectInstance *> *)localVariables;
{
    JPAspectInstance *localInstance = nil;
    
    if (message.message.length == 0) {
        NSString *errorMsg = @"[JPAspect] Message is nil";
        JPAspectLog(@"%@", errorMsg);
        NSAssert(NO, errorMsg);
        return localInstance;
    }
    
    NSArray<NSString *> *messageComponents = [message.message componentsSeparatedByString:@"."];
    
    if (messageComponents.count <= 1) {
        NSString *errorMsg = [NSString stringWithFormat:@"[JPAspect] Message:[%@] is invalid", message.message];
        JPAspectLog(@"%@", errorMsg);
        NSAssert(NO, errorMsg);
        return localInstance;
    }
    
    NSUInteger idx = 0;
    BOOL isClassMethod = NO;
    BOOL isCallSuper = NO;
    id currentTarget = nil;
    
    for (NSString *component in messageComponents) {
        
        if (0 == idx) {
            
            isCallSuper = NO;
            if ([JPAspectDefineClassList containsObject:component]) {
                
                currentTarget = NSClassFromString(component);
                if (currentTarget == nil) {
                    NSString *errorMsg = [NSString stringWithFormat:@"[JPAspect] Message class:[%@] is not exist", component];
                    JPAspectLog(@"%@", errorMsg);
                    NSAssert(NO, errorMsg);
                    break;
                }
                
            } else if ([component isEqualToString:@"self"]) {
                
                currentTarget = aspectInfo.originalInvocation.target;
                
            } else if ([component isEqualToString:@"super"]) {
                
                if (messageComponents.count > 2) {
                    NSString *errorMsg = [NSString stringWithFormat:@"[JPAspect] Message:[%@] super can not contain multiple message invoke", message.message];
                    JPAspectLog(@"%@", errorMsg);
                    NSAssert(NO, errorMsg);
                    break;
                }
                
                SEL superSel = NSSelectorFromString(aspectModel.selName);
                SEL superAliasSel = NSSelectorFromString(jp_superAliasSelString(aspectModel.selName));
                
                if (![aspectInfo.originalInvocation.target respondsToSelector:superAliasSel]) {
                    Class superCls = [aspectInfo.originalInvocation.target superclass];
                    Method superMethod = class_getInstanceMethod(superCls, superSel);
                    IMP superIMP = method_getImplementation(superMethod);
                    Class targetCls = object_isClass(aspectInfo.originalInvocation.target) ? aspectInfo.originalInvocation.target : [aspectInfo.originalInvocation.target class];
                    class_addMethod(targetCls, superAliasSel, superIMP, method_getTypeEncoding(superMethod));
                }
                currentTarget = aspectInfo.originalInvocation.target;
                isCallSuper = YES;
                
            } else if ([localVariables objectForKey:component]) {
                
                currentTarget = [[localVariables objectForKey:component] value];
                
            } else if ([aspectModel.parameterNames containsObject:component]) {
                
                NSUInteger idxOfParamter = [aspectModel.parameterNames indexOfObject:component];
                JPAspectArgument *argument = [self getArgumentWithInvocation:aspectInfo.originalInvocation atIndex:idxOfParamter shouldSetValue:YES];
                
                if (argument == nil || argument.type == JPArgumentTypeUnknown) {
                    NSString *errorMsg = @"[JPAspect] Message parameter is nil";
                    JPAspectLog(@"%@", errorMsg);
                    NSAssert(NO, errorMsg);
                    break;
                }
                
                if (argument.type != JPArgumentTypeObject) {
                    NSString *errorMsg = [NSString stringWithFormat:@"[JPAspect] Message parameter:[%zd] type must be object", argument.type];
                    JPAspectLog(@"%@", errorMsg);
                    NSAssert(NO, errorMsg);
                    break;
                }
                currentTarget = argument.value;
                
            } else {
                
                NSString *errorMsg = [NSString stringWithFormat:@"[JPAspect] JPAspectDefineClassList can not find current class:[%@]", component];
                JPAspectLog(@"%@", errorMsg);
                NSAssert(NO, errorMsg);
                break;
            }
        } else {
            NSMutableArray<JPAspectArgument *> *arguments = [[message.aspectArgumentParameters objectForKey:component] mutableCopy];
            if (arguments.count == 0) {
                NSArray<NSDictionary *> *cureentSelParameters = [message.parameters objectForKey:component];
                if (cureentSelParameters.count > 0) {
                    arguments = [[NSMutableArray alloc] initWithCapacity:cureentSelParameters.count];
                    
                    [cureentSelParameters enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull parameter, NSUInteger idx, BOOL * _Nonnull stop) {
                        
                        JPAspectArgument *argument = nil;
                        JPAspectInstance *localInstance = [localVariables objectForKey:parameter[@"value"]];
                        if (localInstance) {
                            argument = [[JPAspectArgument alloc] init];
                            argument.value = localInstance.value;
                            argument.index = [parameter[@"index"] unsignedIntegerValue] + JPAspectMethodDefaultArgumentsCount;
                            argument.type = [parameter[@"type"] unsignedIntegerValue];
                        } else {
                            if ([aspectModel.parameterNames containsObject:parameter[@"value"]]) {
                                argument = [JPAspect getArgumentWithInvocation:aspectInfo.originalInvocation atIndex:[aspectModel.parameterNames indexOfObject:parameter[@"value"]] shouldSetValue:YES];
                            } else {
                                argument = [JPAspectArgument modelWithArgumentDictionary:parameter];
                            }
                        }
                        [arguments addObject:argument];
                    }];
                    
                    if ([message.aspectArgumentParameters objectForKey:component] == nil) {
                        [message.aspectArgumentParameters setObject:arguments forKey:component];
                    }
                }
            }
            
            isClassMethod = object_isClass(currentTarget) ? YES : NO;
            
            NSString *currentSel = isCallSuper ? jp_superAliasSelString(component) : component;
            localInstance = [self invokeMethodWithTarget:currentTarget selName:currentSel isClassMethod:isClassMethod arguments:arguments];
            currentTarget = localInstance.value;
        }
        
        idx++;
    }
    return localInstance;
}

static NSString * jp_superAliasSelString(NSString *originalSelString) {

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        JPSuperAliasSelectorList = [[NSMutableDictionary alloc] init];
    });
    
    NSString *aliasSelString = [JPSuperAliasSelectorList objectForKey:originalSelString];
    if (aliasSelString == nil) {
        aliasSelString = [@"jp_super" stringByAppendingFormat:@"_%@", originalSelString];
        [JPSuperAliasSelectorList setObject:aliasSelString forKey:originalSelString];
    }
    
    return aliasSelString;
}

@end