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

- (void)pushOperand:(double)operand
{
    [self.operandStack addObject:[NSNumber numberWithDouble:operand]];
}

- (double)performOperation:(NSString *)operation
{
    double result = 0;
    BOOL validOperation = YES;

    if ([operation isEqualToString:@"+"]) {
        result = [self popOperand] + [self popOperand];
    } else if ([operation isEqualToString:@"-"]) {
        double subtrahend = [self popOperand];
        result = [self popOperand] - subtrahend;
    } else if ([operation isEqualToString:@"/"]) {
        double divisor = [self popOperand];
        if (divisor == 0) {
            validOperation = NO;
            [self pushOperand:divisor];
        } else {
            result = [self popOperand] / divisor;
        }
    } else if ([operation isEqualToString:@"*"]) {
        result = [self popOperand] * [self popOperand];
    } else if ([operation isEqualToString:@"sin"]) {
        result = sin([self popOperand]);
    } else if ([operation isEqualToString:@"cos"]) {
        result = cos([self popOperand]);
    } else if ([operation isEqualToString:@"sqrt"]) {
        double operand = [self popOperand];
        if (operand < 0) {
            validOperation = NO;
            [self pushOperand:operand];
        } else {
            result = sqrt(operand);
        }
    } else if ([operation isEqualToString:@"+/-"]) {
        result = -[self popOperand];
    } else if ([operation isEqualToString:@"π"]) {
        result = M_PI;
    } else {
        validOperation = NO;
    }

    if (validOperation) {
        [self pushOperand:result];
    }

    return result;
}

- (void)clear
{
    [self.operandStack removeAllObjects];
}

- (double)popOperand
{
    NSNumber *operand = [self.operandStack lastObject];
    if (operand) {
        [self.operandStack removeLastObject];
    }
    return [operand doubleValue];
}

@end
