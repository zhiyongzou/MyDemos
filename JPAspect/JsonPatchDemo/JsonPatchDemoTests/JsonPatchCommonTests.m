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

- (void)testModifyGetterMethod
{
    NSString *content = self.testC.modifyGetter;
    XCTAssertEqualObjects(content, @"Hello World!");
}

- (void)testInsteadGetterMethod
{
    NSString *content = self.testC.insteadGetter;
    XCTAssertEqualObjects(content, @"Hello World!!!");
}

- (void)testSelfArgument
{
    BOOL success = [self.testC modifySelfArgument:nil];
    XCTAssertTrue(success);
}

- (void)testNilArgument
{
    NSString *content = [self.testC modifyArgumentToNil:@"Hello World!!!"];
    XCTAssertNil(content);
}

- (void)testAndOperator
{
     NSString *content = [self.testC andOperatorTest];
    XCTAssertEqualObjects(content, @"&&");
}

- (void)testOrOperator
{
     NSString *content = [self.testC orOperatorTest];
    XCTAssertEqualObjects(content, @"||");
}

- (void)testDealloc
{
    @autoreleasepool {
         __unused JPTestC *test = [[JPTestC alloc] init];
    }
}

@end
