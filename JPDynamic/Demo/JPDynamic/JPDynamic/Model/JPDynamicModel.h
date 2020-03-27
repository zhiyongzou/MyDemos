//
//  JPDynamicModel.h
//  JPDynamic
//
//  Created by zzyong on 2020/3/27.
//  Copyright © 2020 zzyong. All rights reserved.
//

#import "JPDynamicTypes.h"

NS_ASSUME_NONNULL_BEGIN

@interface JPDynamicModel : NSObject

/// Default JPDynamicHookUnknown
@property (nonatomic, assign) JPDynamicHookType hookType;
/// Class name
@property (nonatomic, strong) NSString *className;
/// Selector name
@property (nonatomic, strong) NSString *selName;
///
@property (nonatomic, assign) BOOL isClassMethod;
/// Target selector argument names
@property (nonatomic, strong, nullable) NSArray<NSString *> *argumentNames;


@end

NS_ASSUME_NONNULL_END
