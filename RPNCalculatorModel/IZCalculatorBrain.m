//
//  IZCalculatorBrain.m
//  RPNCalculator
//
//  Created by Praveen Kumar on 8/4/12.
//  Copyright (c) 2012 InfZen, Inc. All rights reserved.
//

#import "IZCalculatorBrain.h"

@interface IZCalculatorBrain()
@property (nonatomic, readonly, strong) NSMutableArray *programStack;
@end

@implementation IZCalculatorBrain

@synthesize programStack = _programStack;

+ (double)runProgram:(id)program
{
    return [self runProgram:program usingVariableValues:nil];
}

+ (double)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    NSSet *variables = [self variablesUsedInProgram:program];
    for (int i = 0; i < [stack count]; ++i) {
        id item = [program objectAtIndex:i];
        if ([item isKindOfClass:[NSString class]] &&
            [variables containsObject:item]) {
            NSNumber *value = [variableValues valueForKey:item];
            if (!value) {
                value = [NSNumber numberWithDouble:0];
            }
            [stack replaceObjectAtIndex:i withObject:value];
        }
    }
    return [self popOperandOffStack:stack];
}

+ (NSSet *)variablesUsedInProgram:(id)program
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    NSMutableSet *set = [[NSMutableSet alloc] init];
    NSSet *operatorSet = [NSSet setWithObjects:
                          @"+", @"-", @"*", @"/",
                          @"sin", @"cos", @"sqrt", @"log",
                          @"+/-", @"π", @"e", nil];
    for (id item in stack) {
        if ([item isKindOfClass:[NSString class]] &&
            ![operatorSet containsObject:item]) {
            [set addObject:item];
        }
    }
    return [set copy];
}

+ (NSString *)descriptionOfProgram:(id)program
{
    return @"";
}

- (id)program
{
    return [self.programStack copy];
}

- (NSMutableArray *)programStack
{
    if (!_programStack) {
        _programStack = [[NSMutableArray alloc] init];
    }
    return _programStack;
}

- (void)pushOperand:(double)operand
{
    [self.programStack addObject:[NSNumber numberWithDouble:operand]];
}

- (void)pushVariable:(NSString *)variable
{
    [self.programStack addObject:variable];
}

- (double)performOperation:(NSString *)operation
{
    [self.programStack addObject:operation];
    return [IZCalculatorBrain runProgram:self.program];
}

+ (double)popOperandOffStack:(NSMutableArray *)stack
{
    double result = 0;

    id topOfStack = [stack lastObject];
    if (topOfStack) {
        [stack removeLastObject];
    }

    if ([topOfStack isKindOfClass:[NSNumber class]]) {
        result = [topOfStack doubleValue];
    } else if ([topOfStack isKindOfClass:[NSString class]]) {
        NSString *operation = topOfStack;
        if ([operation isEqualToString:@"+"]) {
            result = [self popOperandOffStack:stack] + [self popOperandOffStack:stack];
        } else if ([operation isEqualToString:@"-"]) {
            double subtrahend = [self popOperandOffStack:stack];
            result = [self popOperandOffStack:stack] - subtrahend;
        } else if ([operation isEqualToString:@"/"]) {
            double divisor = [self popOperandOffStack:stack];
            if (divisor == 0) {
                [stack addObject:[NSNumber numberWithDouble:divisor]];
            } else {
                result = [self popOperandOffStack:stack] / divisor;
            }
        } else if ([operation isEqualToString:@"*"]) {
            result = [self popOperandOffStack:stack] * [self popOperandOffStack:stack];
        } else if ([operation isEqualToString:@"sin"]) {
            result = sin([self popOperandOffStack:stack]);
        } else if ([operation isEqualToString:@"cos"]) {
            result = cos([self popOperandOffStack:stack]);
        } else if ([operation isEqualToString:@"sqrt"]) {
            double operand = [self popOperandOffStack:stack];
            if (operand < 0) {
                [stack addObject:[NSNumber numberWithDouble:operand]];
            } else {
                result = sqrt(operand);
            }
        } else if ([operation isEqualToString:@"log"]) {
            result = log10([self popOperandOffStack:stack]);
        } else if ([operation isEqualToString:@"+/-"]) {
            result = -[self popOperandOffStack:stack];
        } else if ([operation isEqualToString:@"π"]) {
            result = M_PI;
        } else if ([operation isEqualToString:@"e"]) {
            result = M_E;
        }
    }
    return result;
}

@end
