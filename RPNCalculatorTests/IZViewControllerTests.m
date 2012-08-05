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

@interface IZViewControllerTests () {
    UIButton *_digitButtons[10];
}

@property (weak, nonatomic, readonly) IZViewController *controller;

@end

@implementation IZViewControllerTests

@synthesize controller = _controller;

// Tests begin here.

- (void)setUp
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard"
                                                         bundle:nil];
    _controller = [storyboard instantiateViewControllerWithIdentifier:@"CalculatorViewController"];
    [_controller performSelectorOnMainThread:@selector(loadView)
                                  withObject:nil
                               waitUntilDone:YES];

    for (int i = 0; i < 10; ++i) {
        _digitButtons[i] = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_digitButtons[i] setTitle:[NSString stringWithFormat:@"%d", i]
                          forState:UIControlStateNormal];
    }
}

- (void)pressDigit:(int)digit
{
    STAssertTrue((digit >= 0) && (digit < 10), nil);
    [self.controller digitPressed:_digitButtons[digit]];
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
    [self.controller digitPressed:_digitButtons[4]];
    STAssertEqualObjects(self.controller.display.text, @"4", nil);
    [self.controller digitPressed:_digitButtons[3]];
    STAssertEqualObjects(self.controller.display.text, @"43", nil);
    [self.controller digitPressed:_digitButtons[2]];
    STAssertEqualObjects(self.controller.display.text, @"432", nil);
}

- (void)testIgnoreLeadingZero
{
    [self.controller digitPressed:_digitButtons[0]];
    STAssertEqualObjects(self.controller.display.text, @"0", nil);
    [self.controller digitPressed:_digitButtons[0]];
    STAssertEqualObjects(self.controller.display.text, @"0", nil);
}

- (void)testDivision
{
    [self pressDigit:9];
    [self pressDigit:0];
    [self.controller enterPressed];
    [self pressDigit:2];
    [self pressDigit:0];
    [self pressOperator:@"/"];
    STAssertEqualObjects(self.controller.display.text, @"4.5", nil);
}

- (void)testMultiplication
{
    [self pressDigit:9];
    [self pressDigit:0];
    [self.controller enterPressed];
    [self pressDigit:2];
    [self pressDigit:0];
    [self pressOperator:@"*"];
    STAssertEqualObjects(self.controller.display.text, @"1800", nil);
}

- (void)testSubtraction
{
    [self pressDigit:8];
    [self pressDigit:8];
    [self.controller enterPressed];
    [self pressDigit:2];
    [self pressDigit:1];
    [self pressOperator:@"-"];
    STAssertEqualObjects(self.controller.display.text, @"67", nil);
}

- (void)testAddition
{
    [self pressDigit:1];
    [self pressDigit:8];
    [self.controller enterPressed];
    [self pressDigit:2];
    [self pressDigit:1];
    [self pressOperator:@"+"];
    STAssertEqualObjects(self.controller.display.text, @"39", nil);
}

@end
