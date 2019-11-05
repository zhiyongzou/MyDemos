//
//  JPAspect+PatchLoad.h
//  JPAspect
//
//  Created by zzyong on 2019/6/5.
//  Copyright © 2019 zzyong. All rights reserved.
//

#import "JPAspect.h"

NS_ASSUME_NONNULL_BEGIN

@interface JPAspect (PatchLoad)

+ (void)loadJsonPatchWithPath:(NSString *)filePath;

+ (void)loadJsonPatchWithData:(NSData *)jsonData;

@end

NS_ASSUME_NONNULL_END
