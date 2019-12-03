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

- (void)testCallInstanceSuper
{
    [self.testC willInitTestObject];
    
    XCTAssertTrue(self.testC.isCallInstanceSuper);
}

- (void)testCallClassSuper
{
    [JPTestC willInitClassTestObject];
    
    XCTAssertTrue(self.testC.isCallClassSuper);
}

- (void)testHookInstanceMethod
{
    
}

- (void)testHookClassMethod
{
    
}

- (void)testCallSingleArgumentMethod
{
    
}

- (void)testCallMultiArgumentMethod
{
    
}

- (void)testHookGetterMethod
{
    
}

@end
