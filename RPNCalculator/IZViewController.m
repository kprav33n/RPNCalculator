//
//  IZViewController.m
//  RPNCalculator
//
//  Created by Praveen Kumar on 8/4/12.
//  Copyright (c) 2012 InfZen, Inc. All rights reserved.
//

#import "IZViewController.h"
#import "IZCalculatorBrain.h"

@interface IZViewController ()

@property (strong, nonatomic, readonly) IZCalculatorBrain *brain;
@property (nonatomic) BOOL isInTheMiddleOfUserInput;
@property (nonatomic) BOOL isFloatingPointNumber;

@end

@implementation IZViewController

@synthesize display = _display;
@synthesize operationsDisplay = _operationDisplay;
@synthesize brain = _brain;
@synthesize isInTheMiddleOfUserInput = _isInTheMiddleOfUserInput;

- (IZCalculatorBrain *)brain
{
    if (!_brain) {
        _brain = [[IZCalculatorBrain alloc] init];
    }
    return _brain;
}

- (IBAction)digitPressed:(UIButton *)sender {
    if (self.isInTheMiddleOfUserInput) {
        self.display.text = [self.display.text stringByAppendingString:sender.currentTitle];
    } else if (![sender.currentTitle isEqualToString:@"0"]){
        self.display.text = sender.currentTitle;
        self.isInTheMiddleOfUserInput = TRUE;
    }
}

- (IBAction)enterPressed {
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.isInTheMiddleOfUserInput = FALSE;
    self.isFloatingPointNumber = FALSE;
    self.operationsDisplay.text = [[self.operationsDisplay.text stringByAppendingString:self.display.text]
                                   stringByAppendingString:@" "];
}

- (IBAction)operatorPressed:(UIButton *)sender {
    if (self.isInTheMiddleOfUserInput) {
        [self enterPressed];
    }
    if ([sender.currentTitle isEqualToString:@"/"]) {
        [self.brain performBinaryOperation:IZDivide];
    } else if ([sender.currentTitle isEqualToString:@"*"]) {
        [self.brain performBinaryOperation:IZMultiply];
    } else if ([sender.currentTitle isEqualToString:@"-"]) {
        [self.brain performBinaryOperation:IZSubtract];
    } else if ([sender.currentTitle isEqualToString:@"+"]) {
        [self.brain performBinaryOperation:IZAdd];
    } else if ([sender.currentTitle isEqualToString:@"sin"]) {
        [self.brain performUnaryOperation:IZSin];
    } else if ([sender.currentTitle isEqualToString:@"cos"]) {
        [self.brain performUnaryOperation:IZCos];
    } else if ([sender.currentTitle isEqualToString:@"sqrt"]) {
        [self.brain performUnaryOperation:IZSqrt];
    } else if ([sender.currentTitle isEqualToString:@"π"]) {
        [self.brain performNullaryOperation:IZPi];
    }
    self.display.text = [NSString stringWithFormat:@"%g", [self.brain lastOperand]];
    self.operationsDisplay.text = [[self.operationsDisplay.text stringByAppendingString:sender.currentTitle]
                                   stringByAppendingString:@" "];
}

- (IBAction)decimalPressed {
    if (self.isFloatingPointNumber) {
        return;
    }
    self.isFloatingPointNumber = TRUE;
    if (self.isInTheMiddleOfUserInput) {
        self.display.text = [self.display.text stringByAppendingString:@"."];
    } else {
        self.display.text = @".";
        self.isInTheMiddleOfUserInput = TRUE;
    }
}

- (IBAction)clearPressed {
    [self.brain clear];
    self.display.text = [NSString stringWithFormat:@"%g", [self.brain lastOperand]];
    self.operationsDisplay.text = @"";
}

@end
