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

+ (id)runProgram:(id)program
{
    return [self runProgram:program usingVariableValues:nil];
}

+ (id)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues
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
    @try {
        return [NSNumber numberWithDouble:[self popOperandOffStack:stack]];
    }
    @catch (NSException *exception) {
        return [exception reason];
    }
}

+ (NSSet *)variablesUsedInProgram:(id)program
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    NSMutableSet *set = [[NSMutableSet alloc] init];
    for (id item in stack) {
        if ([item isKindOfClass:[NSString class]] &&
            ![self isOperator:item]) {
            [set addObject:item];
        }
    }
    return [set copy];
}

+ (NSString *)descriptionOfProgram:(id)program
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }

    NSString *description = [self descriptionOfStack:stack];
    if ([stack count] == 0) {
        return description;
    } else {
        return [NSString stringWithFormat:@"%@, %@", description, [self descriptionOfProgram:[stack copy]]];
    }
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

- (id)performOperation:(NSString *)operation
{
    [self.programStack addObject:operation];
    return [IZCalculatorBrain runProgram:self.program];
}

- (void)undo
{
    [self.programStack removeLastObject];
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
                @throw [NSException exceptionWithName:@"Arithmetic exception"
                                               reason:@"Divide by zero"
                                             userInfo:nil];
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
                @throw [NSException exceptionWithName:@"Arithmetic exception"
                                               reason:@"Complex number error"
                                             userInfo:nil];
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

+ (NSString *)descriptionOfStack:(NSMutableArray *)stack
{
    id topOfStack = [stack lastObject];
    if (topOfStack) {
        [stack removeLastObject];
    }

    if ([topOfStack isKindOfClass:[NSNumber class]]) {
        return [NSString stringWithFormat:@"%g", [topOfStack doubleValue]];
    } else if ([topOfStack isKindOfClass:[NSString class]]) {
        NSString *operator = topOfStack;
        if ([self isNullaryOperator:operator]) {
            return [NSString stringWithFormat:@"%@", operator];
        } else if ([self isUnaryOperator:operator]) {
            NSString *operand = [self descriptionOfStack:stack];
            return [NSString stringWithFormat:@"%@(%@)", operator, operand];
        } else if ([self isBinaryOperator:operator]) {
            NSString *secondOperandFormatString =
            [self needParenthesisWhenUsingOperator:operator
                                       withOperand:[stack lastObject]] ? @"(%@)" : @"%@";
            NSString *secondOperand = [self descriptionOfStack:stack];
            NSString *firstOperandFormatString =
            [self needParenthesisWhenUsingOperator:operator
                                       withOperand:[stack lastObject]] ? @"(%@)" : @"%@";
            NSString *firstOperand = [self descriptionOfStack:stack];
            NSString *formatString = [NSString stringWithFormat:@"%@ %%@ %@",
            firstOperandFormatString, secondOperandFormatString];
            return [NSString stringWithFormat:formatString, firstOperand, operator, secondOperand];
        } else {
            return topOfStack;
        }
    }
    return @"";
}

+ (BOOL)needParenthesisWhenUsingOperator:(NSString *)operator withOperand:(id)operand
{
    if ([operator isEqualToString:@"*"] ||
        [operator isEqualToString:@"/"]) {
        return ([operand isKindOfClass:[NSString class]] &&
                ([operand isEqualToString:@"+"] ||
                 [operand isEqualToString:@"-"]));
    } else {
        return NO;
    }
}

+ (BOOL)isNullaryOperator:(NSString *)operator
{
    static NSSet *nullaryOperators = nil;
    if (!nullaryOperators) {
        nullaryOperators = [NSSet setWithObjects:@"π", @"e", nil];
    }
    return [nullaryOperators containsObject:operator];
}

+ (BOOL)isUnaryOperator:(NSString *)operator
{
    NSSet *unaryOperators = nil;
    if (!unaryOperators) {
        unaryOperators = [NSSet setWithObjects:@"sin", @"cos", @"sqrt", @"log", @"+/-", nil];
    }
    return [unaryOperators containsObject:operator];
}

+ (BOOL)isBinaryOperator:(NSString *)operator
{
    NSSet *binaryOperators = nil;
    if (!binaryOperators) {
        binaryOperators = [NSSet setWithObjects:@"+", @"-", @"*", @"/", nil];
    }
    return [binaryOperators containsObject:operator];
}

+ (BOOL)isOperator:(NSString *)operator
{
    return [self isNullaryOperator:operator] || [self isUnaryOperator:operator] || [self isBinaryOperator:operator];
}

@end
