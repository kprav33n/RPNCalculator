//
//  IZViewControllerTests.m
//  RPNCalculator
//
//  Created by Praveen Kumar on 8/4/12.
//  Copyright (c) 2012 InfZen, Inc. All rights reserved.
//

#import "IZViewControllerTests.h"

#import "IZAppDelegate.h"
#import "IZViewController.h"

@interface IZViewControllerTests ()

@property (weak, nonatomic, readonly) IZViewController *controller;

@end

@implementation IZViewControllerTests

@synthesize controller = _controller;

- (IZViewController *)controller {
    if (!_controller) {
        UIStoryboard *storyboard =
        [UIStoryboard storyboardWithName:@"MainStoryboard"
                                  bundle:nil];
        _controller =
        [storyboard instantiateViewControllerWithIdentifier:@"CalculatorViewController"];
        [_controller performSelectorOnMainThread:@selector(loadView)
                                      withObject:nil
                                   waitUntilDone:YES];
    }
    return _controller;
}

// Tests begin here.

- (void)pressDigit:(NSString *)digit
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:digit forState:UIControlStateNormal];
    [self.controller digitPressed:button];
}

- (void)pressOperator:(NSString *)symbol
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:symbol forState:UIControlStateNormal];
    [self.controller operatorPressed:button];
}

- (void)testInitialization
{
    STAssertNotNil(self.controller, nil);
    STAssertNotNil(self.controller.display, nil);
    STAssertEqualObjects(self.controller.display.text, @"0", nil);
}

- (void)testDigitPressed
{
    [self pressDigit:@"4"];
    STAssertEqualObjects(self.controller.display.text, @"4", nil);
    [self pressDigit:@"3"];
    STAssertEqualObjects(self.controller.display.text, @"43", nil);
    [self pressDigit:@"2"];
    STAssertEqualObjects(self.controller.display.text, @"432", nil);
}

- (void)testIgnoreLeadingZero
{
    [self pressDigit:@"0"];
    STAssertEqualObjects(self.controller.display.text, @"0", nil);
    [self pressDigit:@"0"];
    STAssertEqualObjects(self.controller.display.text, @"0", nil);
}

- (void)testDivision
{
    [self pressDigit:@"9"];
    [self pressDigit:@"0"];
    [self.controller enterPressed];
    [self pressDigit:@"2"];
    [self pressDigit:@"0"];
    [self pressOperator:@"/"];
    STAssertEqualObjects(self.controller.display.text, @"4.5", nil);
}

- (void)testMultiplication
{
    [self pressDigit:@"9"];
    [self pressDigit:@"0"];
    [self.controller enterPressed];
    [self pressDigit:@"2"];
    [self pressDigit:@"0"];
    [self pressOperator:@"*"];
    STAssertEqualObjects(self.controller.display.text, @"1800", nil);
}

- (void)testSubtraction
{
    [self pressDigit:@"8"];
    [self pressDigit:@"8"];
    [self.controller enterPressed];
    [self pressDigit:@"2"];
    [self pressDigit:@"1"];
    [self pressOperator:@"-"];
    STAssertEqualObjects(self.controller.display.text, @"67", nil);
}

- (void)testAddition
{
    [self pressDigit:@"1"];
    [self pressDigit:@"8"];
    [self.controller enterPressed];
    [self pressDigit:@"2"];
    [self pressDigit:@"1"];
    [self pressOperator:@"+"];
    STAssertEqualObjects(self.controller.display.text, @"39", nil);
}

- (void)testDecimalInput
{
    [self pressDigit:@"3"];
    [self.controller decimalPressed];
    [self pressDigit:@"1"];
    [self.controller decimalPressed];
    [self pressDigit:@"4"];
    [self.controller decimalPressed];
    [self pressDigit:@"1"];
    STAssertEqualObjects(self.controller.display.text, @"3.141", nil);
    [self.controller enterPressed];
    [self pressDigit:@"2"];
    [self pressOperator:@"+"];
    STAssertEqualObjects(self.controller.display.text, @"5.141", nil);
    [self.controller decimalPressed];
    [self pressDigit:@"5"];
    STAssertEqualObjects(self.controller.display.text, @".5", nil);
    [self pressOperator:@"+"];
    STAssertEqualObjects(self.controller.display.text, @"5.641", nil);
}

@end
