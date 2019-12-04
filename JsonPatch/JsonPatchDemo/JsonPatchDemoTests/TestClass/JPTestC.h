//
//  JPTestC.h
//  JsonPatchDemoTests
//
//  Created by zzyong on 2019/12/2.
//  Copyright © 2019 zzyong. All rights reserved.
//

#import "JPTestB.h"

NS_ASSUME_NONNULL_BEGIN

@interface JPTestC : JPTestB

- (NSString *)multiArgumentMethod:(NSString *)aString index:(NSUInteger)index flag:(BOOL)flag;

- (NSString *)multiArgumentMethodTest;

@end

NS_ASSUME_NONNULL_END
