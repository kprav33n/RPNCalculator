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

@end
