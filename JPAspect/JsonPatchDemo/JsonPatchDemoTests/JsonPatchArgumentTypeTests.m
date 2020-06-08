//
//  JsonPatchArgumentTypeTests.m
//  JsonPatchDemoTests
//
//  Created by zzyong on 2019/12/2.
//  Copyright © 2019 zzyong. All rights reserved.
//

#import "JPTestA.h"
#import "JPTestB.h"
#import <XCTest/XCTest.h>
#import "JPAspect+PatchLoad.h"

@interface JsonPatchArgumentTypeTests : XCTestCase

@property (nonatomic, strong) JPTestA *testA;

@end

@implementation JsonPatchArgumentTypeTests

/// Put setup code here. This method is called before the invocation of each test method in the class.
- (void)setUp
{
    self.testA = [[JPTestA alloc] init];
    
    // load json patch
    NSString *patchPath = [[NSBundle mainBundle] pathForResource:@"AspectConfigTestArgumentType" ofType:@"json"];
    [JPAspect loadJsonPatchWithPath:patchPath];
}

/// Put teardown code here. This method is called after the invocation of each test method in the class.
- (void)tearDown
{
    self.testA = nil;
}

#pragma mark - Tests

- (void)testModifyArgumentObject
{
    self.testA.name = @"aa";
    BOOL isEqual = [self.testA.name isEqualToString:@"jp"];
    XCTAssertTrue(isEqual, @"Must equal");
}

- (void)testModifyArgumentClass
{
    self.testA.myClass = [JPTestA class];
    BOOL isEqual = [self.testA.myClass isEqual:[JPTestB class]];
    XCTAssertTrue(isEqual, @"Must equal");
}

- (void)testModifyArgumentBool
{
    self.testA.isTrue = YES;
    BOOL isEqual = !self.testA.isTrue;
    XCTAssertTrue(isEqual, @"Must equal");
}

- (void)testModifyArgumentInteger
{
    self.testA.integer = -11;
    BOOL isEqual = (self.testA.integer == -22);
    XCTAssertTrue(isEqual, @"Must equal");
}

- (void)testModifyArgumentUInteger
{
    self.testA.uInteger = 11;
    BOOL isEqual = (self.testA.uInteger == 22);
    XCTAssertTrue(isEqual, @"Must equal");
}

- (void)testModifyArgumentShort
{
    self.testA.myShort = -11;
    BOOL isEqual = (self.testA.myShort == -22);
    XCTAssertTrue(isEqual, @"Must equal");
}

- (void)testModifyArgumentUnsignedShort
{
    self.testA.myUnsignedShort = 11;
    BOOL isEqual = (self.testA.myUnsignedShort == 22);
    XCTAssertTrue(isEqual, @"Must equal");
}

- (void)testModifyArgumentLongLong
{
    self.testA.myLongLong = 11;
    BOOL isEqual = (self.testA.myLongLong == 22);
    XCTAssertTrue(isEqual, @"Must equal");
}
- (void)testModifyArgumentUnsignedLongLong
{
    self.testA.myUnsignedLongLong = 11;
    BOOL isEqual = (self.testA.myUnsignedLongLong == 22);
    XCTAssertTrue(isEqual, @"Must equal");
}

- (void)testModifyArgumentFloat
{
    self.testA.myFloat = 11.11;
    BOOL isEqual = (self.testA.myFloat == (float)22.22);
    XCTAssertTrue(isEqual, @"Must equal");
}

- (void)testModifyArgumentCGFloat
{
    self.testA.myCGFloat = 11.11;
    BOOL isEqual = (self.testA.myCGFloat == (CGFloat)-22.22);
    XCTAssertTrue(isEqual, @"Must equal");
}

- (void)testModifyArgumentInt
{
    self.testA.myInt = 11;
    BOOL isEqual = (self.testA.myInt == -22);
    XCTAssertTrue(isEqual, @"Must equal");
}

- (void)testModifyArgumentUnsignedInt
{
    self.testA.myUnsignedInt = 11;
    BOOL isEqual = (self.testA.myUnsignedInt == 22);
    XCTAssertTrue(isEqual, @"Must equal");
}

- (void)testModifyArgumentSEL
{
    self.testA.selector = @selector(selA);
    BOOL isEqual = ([NSStringFromSelector(self.testA.selector) isEqualToString:@"selB"]);
    XCTAssertTrue(isEqual, @"Must equal");
}

- (void)testModifyArgumentSize
{
    self.testA.size = CGSizeZero;
    BOOL isEqual = CGSizeEqualToSize(self.testA.size, CGSizeMake(1, 1.1));
    XCTAssertTrue(isEqual, @"Must equal");
}

- (void)testModifyArgumentPoint
{
    self.testA.point = CGPointZero;
    BOOL isEqual = CGPointEqualToPoint(self.testA.point, CGPointMake(1, 1.1));
    XCTAssertTrue(isEqual, @"Must equal");
}

- (void)testModifyArgumentRect
{
    self.testA.rect = CGRectZero;
    BOOL isEqual = CGRectEqualToRect(self.testA.rect, CGRectMake(0, 0, 1, 1.1));
    XCTAssertTrue(isEqual, @"Must equal");
}

- (void)testModifyArgumentEdgeInsets
{
    self.testA.edgeInsets = UIEdgeInsetsZero;
    BOOL isEqual = UIEdgeInsetsEqualToEdgeInsets(self.testA.edgeInsets, UIEdgeInsetsMake(0, 0, 1, 1.1));
    XCTAssertTrue(isEqual, @"Must equal");
}

- (void)testModifyArgumentRange
{
    self.testA.range = NSMakeRange(0, 0);
    BOOL isEqual = NSEqualRanges(self.testA.range, NSMakeRange(1, 1.1));
    XCTAssertTrue(isEqual, @"Must equal");
}

@end
