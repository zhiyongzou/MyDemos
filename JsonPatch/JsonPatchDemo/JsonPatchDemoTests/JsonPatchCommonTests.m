//
//  JsonPatchCommonTests.m
//  JsonPatchDemoTests
//
//  Created by zzyong on 2019/12/2.
//  Copyright © 2019 zzyong. All rights reserved.
//

#import "JPTestB.h"
#import "JPTestC.h"
#import <XCTest/XCTest.h>
#import "JPAspect+PatchLoad.h"

@interface JsonPatchCommonTests : XCTestCase

@property (nonatomic, strong) JPTestC *testC;

@end

@implementation JsonPatchCommonTests

- (void)setUp
{
    self.testC = [[JPTestC alloc] init];
    
    // load json patch
    NSString *patchPath = [[NSBundle mainBundle] pathForResource:@"AspectConfigTestCommon" ofType:@"json"];
    [JPAspect loadJsonPatchWithPath:patchPath];
}

- (void)tearDown
{
    self.testC.isCallClassSuper = NO;
    self.testC = nil;
}

- (void)testCallSuperInstanceMethod
{
    [self.testC willInitTestObject];
    
    XCTAssertTrue(self.testC.isCallInstanceSuper);
}

- (void)testCallSuperClassMethod
{
    [JPTestC willInitClassTestObject];
    
    XCTAssertTrue(self.testC.isCallClassSuper);
}

- (void)testCallSuperInstanceMethodWithArgument
{
    NSString *content = [self.testC contentWithCustomString:@"JPTestC"];
    XCTAssertEqualObjects(content, @"jp_JPTestC");
}

- (void)testCallMultiArgumentMethod
{
    NSString *content = [self.testC multiArgumentMethodTest];
    XCTAssertEqualObjects(content, @"JPTestC_1_0");
}

- (void)testHookIsEqualToNumberMethod
{
    NSNumber *nilNumber = nil;
    XCTAssertTrue([@(1) isEqualToNumber:nilNumber]);
}

@end
