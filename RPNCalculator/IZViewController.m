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

@property (strong, nonatomic) IZCalculatorBrain *brain;
@property (nonatomic) BOOL isInTheMiddleOfUserInput;
@property (strong, nonatomic) NSDictionary *variableValues;

@end

@implementation IZViewController

@synthesize display = _display;
@synthesize operationsDisplay = _operationDisplay;
@synthesize variablesDisplay = _variablesDisplay;
@synthesize brain = _brain;
@synthesize isInTheMiddleOfUserInput = _isInTheMiddleOfUserInput;
@synthesize variableValues = _variableValues;

- (IZCalculatorBrain *)brain
{
    if (!_brain) {
        _brain = [[IZCalculatorBrain alloc] init];
    }
    return _brain;
}

- (NSDictionary *)variableValues
{
    if (!_variableValues) {
        _variableValues = [[NSDictionary alloc] init];
    }
    return _variableValues;
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
    [self updateOperationsDisplay];
}

- (IBAction)operatorPressed:(UIButton *)sender {
    if (self.isInTheMiddleOfUserInput) {
        [self enterPressed];
    }
    [self.brain performOperation:sender.currentTitle];
    [self updateDisplay];
    [self updateOperationsDisplay];
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
    self.brain = nil;
    [self clearDisplay];
    [self updateOperationsDisplay];
    [self updateVariablesDisplay];
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

- (IBAction)signChangePressed:(UIButton *)sender {
    if (self.isInTheMiddleOfUserInput) {
        if ([self.display.text characterAtIndex:0] == '-') {
            self.display.text = [self.display.text substringFromIndex:1];
        } else {
            self.display.text = [@"-" stringByAppendingString:self.display.text];
        }
    } else {
        [self operatorPressed:sender];
    }
}

- (IBAction)variablePressed:(UIButton *)sender {
    if (self.isInTheMiddleOfUserInput) {
        [self enterPressed];
    }
    [self.brain pushVariable:sender.currentTitle];
    self.display.text = sender.currentTitle;
    [self updateOperationsDisplay];
    [self updateVariablesDisplay];
}

- (IBAction)testPressed:(UIButton *)sender {
    if ([sender.currentTitle isEqualToString:@"Test 1"]) {
        self.variableValues = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:10], @"x",
                               [NSNumber numberWithDouble:20], @"a", nil];
    } else if ([sender.currentTitle isEqualToString:@"Test 2"]) {
        self.variableValues = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:-4], @"a",
                               [NSNumber numberWithDouble:3], @"b", nil];
    } else if ([sender.currentTitle isEqualToString:@"Test 3"]) {
        self.variableValues = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:0.5], @"x",
                               [NSNumber numberWithDouble:3.4], @"b", nil];
    } else {
        return;
    }
    [self updateDisplay];
    [self updateVariablesDisplay];
    [self updateOperationsDisplay];
}

- (IBAction)undoPressed {
    if (self.isInTheMiddleOfUserInput) {
        if ([self.display.text length] > 1) {
            self.display.text = [self.display.text substringToIndex:self.display.text.length - 1];
        } else {
            [self updateDisplay];
            self.isInTheMiddleOfUserInput = NO;
        }
    } else {
        [self.brain undo];
        [self updateDisplay];
        [self updateOperationsDisplay];
        [self updateVariablesDisplay];
    }
}

- (void)clearDisplay
{
    self.display.text = @"0";
    self.isInTheMiddleOfUserInput = NO;
}

- (void)updateDisplay
{
    self.display.text = [NSString stringWithFormat:@"%g",
                         [IZCalculatorBrain runProgram:[self.brain program]
                                   usingVariableValues:self.variableValues]];
}

- (void)updateOperationsDisplay
{
    self.operationsDisplay.text = [IZCalculatorBrain descriptionOfProgram:[self.brain program]];
}

- (void)updateVariablesDisplay
{
    self.variablesDisplay.text = @"";
    NSSet *variables = [IZCalculatorBrain variablesUsedInProgram:[self.brain program]];
    for (id variable in variables) {
        if ([variable isKindOfClass:[NSString class]]) {
            NSNumber *value = [self.variableValues valueForKey:variable];
            if (value) {
                self.variablesDisplay.text = [self.variablesDisplay.text stringByAppendingFormat:@"%@: %g ", variable, [value doubleValue]];
            } else {
                self.variablesDisplay.text = [self.variablesDisplay.text stringByAppendingFormat:@"%@: undefined ", variable];

            }
        }
    }
}

@end
