//
//  JPAspect+PatchLoad.m
//  JPAspect
//
//  Created by zzyong on 2019/6/5.
//  Copyright © 2019 zzyong. All rights reserved.
//

#import "JPAspectTypes.h"
#import <UIKit/UIDevice.h>
#import "JPAspect+PatchLoad.h"

@implementation JPAspect (PatchLoad)

+ (void)loadJsonPatchWithPath:(NSString *)filePath
{
    NSError *error = nil;
    NSData *jsonData = [NSData dataWithContentsOfFile:filePath options:NSDataReadingMappedIfSafe error:&error];
    if (error) {
        JPAspectLog(@"%@", error);
        return;
    }
    [self loadJsonPatchWithData:jsonData];
}

+ (void)loadJsonPatchWithData:(NSData *)jsonData
{
    if (!jsonData) {
        JPAspectLog(@"Json data is nil");
        return;
    }
    
    NSError *error = nil;
    NSDictionary *patchDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    
    if (error) {
        JPAspectLog(@"%@", error);
        return;
    }
    
    if (patchDic == nil) {
        JPAspectLog(@"patch dictionary is nil");
        return;
    }
    
    [self setupAspectDefineClassList:[patchDic objectForKey:@"AspectDefineClassList"]];
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    
    NSArray<NSDictionary *> *patchs = [patchDic objectForKey:@"Patchs"];
    [patchs enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull patch, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *applySystemVersions = patch[@"ApplySystemVersions"];
        if ((applySystemVersions == nil) || [self shouldRunPatchWithApplySystemVersions:applySystemVersions currentSystemVersion:systemVersion]) {
            [self hookMethodWithAspectDictionary:patch];
            JPAspectLog(@"Run Patch %@", [NSString stringWithFormat:@"[%@ %@]", patch[@"className"], patch[@"selName"]]);
        }
    }];
}

+ (BOOL)shouldRunPatchWithApplySystemVersions:(NSArray*)applySystemVersions currentSystemVersion:(NSString *)systemVersion
{
    BOOL shouldRun = NO;
    for (NSString *version in applySystemVersions) {
        if ([version isEqualToString:@"*"] || [version isEqualToString:systemVersion]) {
            shouldRun = YES;
            break;
        } else if ([version hasSuffix:@"*"]) {
            NSString *versionPrefix = [version stringByReplacingOccurrencesOfString:@"*" withString:@""];
            if ([systemVersion hasPrefix:versionPrefix]) {
                shouldRun = YES;
                break;
            }
        }
    }
    
    return shouldRun;
}

@end
