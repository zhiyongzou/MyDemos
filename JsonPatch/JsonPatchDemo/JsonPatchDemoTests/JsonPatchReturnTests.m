//
//  JsonPatchReturnTests.m
//  JsonPatchDemoTests
//
//  Created by zzyong on 2019/12/6.
//  Copyright © 2019 zzyong. All rights reserved.
//

#import "JPTestD.h"
#import <XCTest/XCTest.h>
#import "JPAspect+PatchLoad.h"

@interface JsonPatchReturnTests : XCTestCase

@property (nonatomic, strong) JPTestD *testD;

@end

@implementation JsonPatchReturnTests

- (void)setUp
{
    self.testD = [[JPTestD alloc] init];
    
    // load json patch
    NSString *patchPath = [[NSBundle mainBundle] pathForResource:@"AspectConfigTestReturn" ofType:@"json"];
    [JPAspect loadJsonPatchWithPath:patchPath];
}

- (void)tearDown
{
    self.testD = nil;
}

- (void)testReturnObject
{
    NSNumber *result = [self.testD returnObject];
    XCTAssertEqualObjects(result, @(1));

    result = [JPTestD returnObject];
    XCTAssertEqualObjects(result, @(1));
}

- (void)testReturnBool
{
    BOOL result = [self.testD returnBool];
    XCTAssertTrue(result);

    result = [JPTestD returnBool];
    XCTAssertTrue(result);
}

- (void)testReturnLong
{
    long result = [self.testD returnLong];
    XCTAssertEqual(result, -11111);

    result = [JPTestD returnLong];
    XCTAssertEqual(result, -11111);
}

- (void)testReturnUnsignedLong
{
    unsigned long result = [self.testD returnUnsignedLong];
    XCTAssertEqual(result, 11111);

    result = [JPTestD returnUnsignedLong];
    XCTAssertEqual(result, 11111);
}

- (void)testReturnDouble
{
    CGFloat result = [self.testD returnDouble];
    XCTAssertEqual(result, 1.11);

    result = [JPTestD returnDouble];
    XCTAssertEqual(result, 1.11);
}

- (void)testReturnInt
{
    int result = [self.testD returnInt];
    XCTAssertEqual(result, 1);

    result = [JPTestD returnInt];
    XCTAssertEqual(result, 1);
}

//- (void)testReturnSize
//{
//    CGSize result = [self.testD returnSize];
//    BOOL isEqual = CGSizeEqualToSize(result, CGSizeMake(1, 1.1));
//    XCTAssertTrue(isEqual);
//
//    result = [JPTestD returnSize];
//    isEqual = CGSizeEqualToSize(result, CGSizeMake(1, 1.1));
//    XCTAssertTrue(isEqual);
//}
//
//- (void)testReturnPoint
//{
//    CGPoint result = [self.testD returnPoint];
//    BOOL isEqual = CGPointEqualToPoint(result, CGPointMake(1, 1.1));
//    XCTAssertTrue(isEqual);
//
//    result = [JPTestD returnPoint];
//    isEqual = CGPointEqualToPoint(result, CGPointMake(1, 1.1));
//    XCTAssertTrue(isEqual);
//}

- (void)testReturnRect
{
    CGRect result = [self.testD returnRect];
    BOOL isEqual = CGRectEqualToRect(result, CGRectMake(1, 1, 1.1, 1.1));
    XCTAssertTrue(isEqual);

    result = [JPTestD returnRect];
    isEqual = CGRectEqualToRect(result, CGRectMake(1, 1, 1.1, 1.1));
    XCTAssertTrue(isEqual);
}

- (void)testReturnEdgeInsets
{
    UIEdgeInsets result = [self.testD returnEdgeInsets];
    BOOL isEqual = UIEdgeInsetsEqualToEdgeInsets(result, UIEdgeInsetsMake(1, 1, 1.1, 1.1));
    XCTAssertTrue(isEqual);

    result = [JPTestD returnEdgeInsets];
    isEqual = UIEdgeInsetsEqualToEdgeInsets(result, UIEdgeInsetsMake(1, 1, 1.1, 1.1));
    XCTAssertTrue(isEqual);
}

//- (void)testReturnRange
//{
//    NSRange result = [self.testD returnRange];
//    BOOL isEqual = NSEqualRanges(result, NSMakeRange(1, 1));
//    XCTAssertTrue(isEqual);
//
//    result = [JPTestD returnRange];
//    isEqual = NSEqualRanges(result, NSMakeRange(1, 1));
//    XCTAssertTrue(isEqual);
//}

@end
