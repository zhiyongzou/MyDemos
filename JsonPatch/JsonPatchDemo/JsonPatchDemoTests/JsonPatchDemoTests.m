//
//  JsonPatchDemoTests.m
//  JsonPatchDemoTests
//
//  Created by zzyong on 2019/11/5.
//  Copyright © 2019 zzyong. All rights reserved.
//

#import "JPTestA.h"
#import "JPTestB.h"
#import <XCTest/XCTest.h>
#import "JPAspect+PatchLoad.h"

@interface JsonPatchDemoTests : XCTestCase

@property (nonatomic, strong) JPTestA *testA;

@end

@implementation JsonPatchDemoTests

/// Put setup code here. This method is called before the invocation of each test method in the class.
- (void)setUp
{
    [self commonSetup];
}

/// Put teardown code here. This method is called after the invocation of each test method in the class.
- (void)tearDown
{
    self.testA = nil;
}

- (void)testPerformanceExample
{
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

#pragma mark - Setup

- (void)commonSetup
{
    self.testA = [[JPTestA alloc] init];
}

#pragma mark - Tests

- (void)testModifyMethodArgument
{
    // load json patch
    NSString *patchPath = [[NSBundle mainBundle] pathForResource:@"AspectConfigTestArgument" ofType:@"json"];
    [JPAspect loadJsonPatchWithPath:patchPath];
    
    self.testA.name = @"aa";
    BOOL isEqual = [self.testA.name isEqualToString:@"jp"];
    XCTAssertTrue(isEqual, @"Must equal");
    
    self.testA.myClass = [JPTestA class];
    isEqual = [self.testA.myClass isEqual:[JPTestB class]];
    XCTAssertTrue(isEqual, @"Must equal");
    
    self.testA.isTrue = YES;
    isEqual = !self.testA.isTrue;
    XCTAssertTrue(isEqual, @"Must equal");
    
    self.testA.integer = -11;
    isEqual = (self.testA.integer == -22);
    XCTAssertTrue(isEqual, @"Must equal");
    
    self.testA.uInteger = 11;
    isEqual = (self.testA.uInteger == 22);
    XCTAssertTrue(isEqual, @"Must equal");
    
    self.testA.myShort = -11;
    isEqual = (self.testA.myShort == -22);
    XCTAssertTrue(isEqual, @"Must equal");
    
    self.testA.myUnsignedShort = 11;
    isEqual = (self.testA.myUnsignedShort == 22);
    XCTAssertTrue(isEqual, @"Must equal");
    
    self.testA.myLongLong = 11;
    isEqual = (self.testA.myLongLong == 22);
    XCTAssertTrue(isEqual, @"Must equal");
    
    self.testA.myUnsignedLongLong = 11;
    isEqual = (self.testA.myUnsignedLongLong == 22);
    XCTAssertTrue(isEqual, @"Must equal");
    
    self.testA.myFloat = 11.11;
    isEqual = (self.testA.myFloat == (float)22.22);
    XCTAssertTrue(isEqual, @"Must equal");
    
    self.testA.myCGFloat = 11.11;
    isEqual = (self.testA.myCGFloat == (CGFloat)-22.22);
    XCTAssertTrue(isEqual, @"Must equal");
    
    self.testA.myInt = 11;
    isEqual = (self.testA.myInt == -22);
    XCTAssertTrue(isEqual, @"Must equal");
    
    self.testA.myUnsignedInt = 11;
    isEqual = (self.testA.myUnsignedInt == 22);
    XCTAssertTrue(isEqual, @"Must equal");
    
    self.testA.selector = @selector(testSelA);
    isEqual = ([NSStringFromSelector(self.testA.selector) isEqualToString:@"testSelB"]);
    XCTAssertTrue(isEqual, @"Must equal");
    
    self.testA.size = CGSizeZero;
    isEqual = CGSizeEqualToSize(self.testA.size, CGSizeMake(1, 1.1));
    XCTAssertTrue(isEqual, @"Must equal");
    
    self.testA.point = CGPointZero;
    isEqual = CGPointEqualToPoint(self.testA.point, CGPointMake(1, 1.1));
    XCTAssertTrue(isEqual, @"Must equal");
    
    self.testA.rect = CGRectZero;
    isEqual = CGRectEqualToRect(self.testA.rect, CGRectMake(0, 0, 1, 1.1));
    XCTAssertTrue(isEqual, @"Must equal");
    
    self.testA.edgeInsets = UIEdgeInsetsZero;
    isEqual = UIEdgeInsetsEqualToEdgeInsets(self.testA.edgeInsets, UIEdgeInsetsMake(0, 0, 1, 1.1));
    XCTAssertTrue(isEqual, @"Must equal");
}

@end
