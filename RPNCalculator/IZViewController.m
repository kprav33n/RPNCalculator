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
@property (strong, nonatomic) NSString *userInputHistory;

@end

@implementation IZViewController

@synthesize display = _display;
@synthesize operationsDisplay = _operationDisplay;
@synthesize brain = _brain;
@synthesize isInTheMiddleOfUserInput = _isInTheMiddleOfUserInput;
@synthesize userInputHistory = _userInputHistory;

- (IZCalculatorBrain *)brain
{
    if (!_brain) {
        _brain = [[IZCalculatorBrain alloc] init];
    }
    return _brain;
}

- (NSString *)userInputHistory
{
    if (!_userInputHistory)  {
        _userInputHistory = @"";
    }
    return _userInputHistory;
}

- (IBAction)digitPressed:(UIButton *)sender {
    if (self.isInTheMiddleOfUserInput) {
        self.display.text = [self.display.text stringByAppendingString:sender.currentTitle];
    } else if (!([self.display.text isEqualToString:@"0"] &&
                 [sender.currentTitle isEqualToString:@"0"])){
        self.display.text = sender.currentTitle;
        self.isInTheMiddleOfUserInput = YES;
    }
}

- (IBAction)enterPressed {
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.isInTheMiddleOfUserInput = NO;
    self.userInputHistory = [self.userInputHistory stringByAppendingString:
                             [self.display.text stringByAppendingString:@" "]];
    self.operationsDisplay.text = self.userInputHistory;
}

- (IBAction)operatorPressed:(UIButton *)sender {
    if (self.isInTheMiddleOfUserInput) {
        [self enterPressed];
    }
    self.display.text = [NSString stringWithFormat:@"%g", [self.brain performOperation:sender.currentTitle]];
    self.userInputHistory = [self.userInputHistory stringByAppendingString:
                             [sender.currentTitle stringByAppendingString:@" "]];
    self.operationsDisplay.text = [self.userInputHistory stringByAppendingString:@"="];
}

- (IBAction)decimalPressed {
    if (self.isInTheMiddleOfUserInput) {
        if ([self.display.text rangeOfString:@"."].location == NSNotFound) {
            self.display.text = [self.display.text stringByAppendingString:@"."];
        }
    } else {
        self.display.text = @".";
        self.isInTheMiddleOfUserInput = YES;
    }
}

- (IBAction)clearPressed {
    [self.brain clear];
    self.display.text = @"0";
    self.userInputHistory = @"";
    self.operationsDisplay.text = self.userInputHistory;
    self.isInTheMiddleOfUserInput = NO;
}

- (IBAction)deletePressed {
    if (!self.isInTheMiddleOfUserInput) {
        return;
    }

    if (self.display.text.length == 1) {
        self.display.text = @"0";
        self.isInTheMiddleOfUserInput = NO;
    } else {
        self.display.text = [self.display.text substringToIndex:self.display.text.length - 1];
    }
}

@end
