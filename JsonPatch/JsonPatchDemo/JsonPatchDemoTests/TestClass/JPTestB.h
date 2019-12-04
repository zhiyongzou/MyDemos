//
//  JPTestB.h
//  JsonPatchDemoTests
//
//  Created by zzyong on 2019/12/2.
//  Copyright © 2019 zzyong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JPTestB : NSObject

- (void)selA;

- (void)selB;

@property (nonatomic, assign) BOOL isCallInstanceSuper;
@property (nonatomic, assign) BOOL isCallClassSuper;

- (void)willInitTestObject;

+ (void)willInitClassTestObject;

- (NSString *)contentWithCustomString:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
