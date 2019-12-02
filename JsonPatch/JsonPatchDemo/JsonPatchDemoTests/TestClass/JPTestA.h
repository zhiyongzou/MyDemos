//
//  JPTestA.h
//  JsonPatchDemoTests
//
//  Created by zzyong on 2019/12/2.
//  Copyright © 2019 zzyong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JPTestA : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) Class myClass;
@property (nonatomic, assign) BOOL isTrue;
@property (nonatomic, assign) NSInteger integer;
@property (nonatomic, assign) NSUInteger uInteger;
@property (nonatomic, assign) short myShort;
@property (nonatomic, assign) unsigned short myUnsignedShort;
@property (nonatomic, assign) long long myLongLong;
@property (nonatomic, assign) unsigned long long myUnsignedLongLong;
@property (nonatomic, assign) float myFloat;
@property (nonatomic, assign) CGFloat myCGFloat;
@property (nonatomic, assign) int myInt;
@property (nonatomic, assign) unsigned int myUnsignedInt;
@property (nonatomic, assign) SEL selector;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint point;
@property (nonatomic, assign) CGRect rect;
@property (nonatomic, assign) UIEdgeInsets edgeInsets;

@end

NS_ASSUME_NONNULL_END
