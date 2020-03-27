//
//  JPDynamic.m
//  JPDynamic
//
//  Created by zzyong on 2020/3/27.
//  Copyright © 2020 zzyong. All rights reserved.
//

#import "JPDynamic.h"
#import "JPDynamicTypes.h"
#import "JPDynamicModel.h"

// Third
#import <objc/runtime.h>
#import <objc/message.h>
#import <JRSwizzle/JRSwizzle.h>

@implementation JPDynamic

+ (void)hookSelectorWithDynamicDictionary:(NSDictionary *)dynamicDictionary
{
    
}

+ (void)hookMethodWithDynamicModel:(JPDynamicModel *)dynamicModel
{
    if (!dynamicModel) {
        NSAssert(0, @"Dynamic model is nil");
        return;
    }
    
    if (JPDynamicHookUnknown == dynamicModel.hookType) {
        NSAssert(NO, @"Hook type is unknown");
        return;
    }
    
    Class targetCls = NSClassFromString(dynamicModel.className);
    if (targetCls == nil) {
        NSAssert(NO, @"Target class:[%@] is nil", dynamicModel.className);
        return;
    }
    
    SEL targetSel = NSSelectorFromString(dynamicModel.selName);
    if (targetSel == nil) {
        NSAssert(NO, @"Target selector:[%@] is nil", dynamicModel.selName);
        return;
    }
    
    // Class method
    if (dynamicModel.isClassMethod) {
        targetCls = JPGetClass(targetCls);
    }
    
    NSError *error = nil;
    [targetCls jp_swizzleMethod:targetSel withBlock:^{
        
    } error:&error];
    
    if (error) {
        NSAssert(NO, @"%@ %@ Hook error:%@", dynamicModel.className, dynamicModel.selName, error);
    }
}

#pragma mark - NSInvocation

#pragma mark - Base

+ (NSInvocation*)jp_swizzleMethod:(SEL)origSel withBlock:(id)block error:(NSError**)error
{
    IMP blockIMP = imp_implementationWithBlock(block);
    NSString *blockSelectorString = [NSString stringWithFormat:@"_jp_block_%@_%p", NSStringFromSelector(origSel), self];
    SEL blockSel = sel_registerName([blockSelectorString cStringUsingEncoding:NSUTF8StringEncoding]);
    
    Method origSelMethod = class_getInstanceMethod(self, origSel);
    
    if (origSelMethod == NULL) {
        NSCAssert(NO, @"Original selector(%@) method is null", NSStringFromSelector(origSel));
    }
    
    const char* origSelMethodArgs = method_getTypeEncoding(origSelMethod);
    __unused BOOL addedBlock =  class_addMethod(self, blockSel, blockIMP, origSelMethodArgs);
    NSCAssert(addedBlock, @"%@ already contains a method implementation with that %@", self, blockSelectorString);

    NSMethodSignature *origSig = [NSMethodSignature signatureWithObjCTypes:origSelMethodArgs];
    NSInvocation *origInvocation = [NSInvocation invocationWithMethodSignature:origSig];
    origInvocation.selector = blockSel;

    [self jr_swizzleMethod:origSel withMethod:blockSel error:nil];

    return origInvocation;
}

@end
