//
//  IZCalculatorBrain.m
//  RPNCalculator
//
//  Created by Praveen Kumar on 8/4/12.
//  Copyright (c) 2012 InfZen, Inc. All rights reserved.
//

#import "IZCalculatorBrain.h"

@interface IZCalculatorBrain()
@property (nonatomic, readonly, strong) NSMutableArray *operandStack;
@end

@implementation IZCalculatorBrain

@synthesize operandStack = _operandStack;

- (NSMutableArray *)operandStack
{
    if (!_operandStack) {
        _operandStack = [[NSMutableArray alloc] init];
    }
    return _operandStack;
}

- (double)lastOperand
{
    return [[self.operandStack lastObject] doubleValue];
}

- (void)pushOperand:(double)operand
{
    [self.operandStack addObject:[NSNumber numberWithDouble:operand]];
}

- (void)performNullaryOperation:(IZNullaryOperation)operation
{
    [self.operandStack addObject:[NSNumber numberWithDouble:M_PI]];
}

- (void)performUnaryOperation:(IZUnaryOperation)operation
{
    double operand = [[self.operandStack lastObject] doubleValue];
    [self.operandStack removeLastObject];

    double result = 0;
    switch (operation) {
        case IZSin:
            result = sin(operand);
            break;

        case IZCos:
            result = cos(operand);
            break;

        case IZSqrt:
            result = sqrt(operand);
            break;

        default:
            break;
    }

    [self.operandStack addObject:[NSNumber numberWithDouble:result]];
}

- (void)performBinaryOperation:(IZBinaryOperation)operation
{
    if ([self.operandStack count] < 2) {
        return;
    }

    double secondOperand = [[self.operandStack lastObject] doubleValue];
    [self.operandStack removeLastObject];
    double firstOperand = [[self.operandStack lastObject] doubleValue];
    [self.operandStack removeLastObject];

    double result = 0;
    BOOL updateResult = TRUE;

    switch (operation) {
        case IZAdd:
            result = firstOperand + secondOperand;
            break;

        case IZSubtract:
            result = firstOperand - secondOperand;
            break;

        case IZDivide:
            result = firstOperand / secondOperand;
            break;

        case IZMultiply:
            result = firstOperand * secondOperand;
            break;

        default:
            updateResult = FALSE;
            break;
    }

    if (updateResult) {
        [self.operandStack addObject:[NSNumber numberWithDouble:result]];
    } else {
        [self.operandStack addObject:[NSNumber numberWithDouble:firstOperand]];
        [self.operandStack addObject:[NSNumber numberWithDouble:secondOperand]];
    }
}

- (void)clear
{
    [self.operandStack removeAllObjects];
}

- (NSUInteger)operandsCount
{
    return [self.operandStack count];
}

@end
