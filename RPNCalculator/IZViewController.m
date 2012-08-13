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
    self.display.text = [NSString stringWithFormat:@"%g", [self.brain performOperation:sender.currentTitle]];
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
    self.display.text = @"0";
    self.operationsDisplay.text = @"";
}

@end
