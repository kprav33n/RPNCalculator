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

@end

@implementation IZViewController

@synthesize display = _display;
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
    }
    self.display.text = [NSString stringWithFormat:@"%g", [self.brain lastOperand]];
}

@end
