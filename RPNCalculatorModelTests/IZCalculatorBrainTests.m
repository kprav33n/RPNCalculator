//
//  IZCalculatorBrainTests.m
//  RPNCalculator
//
//  Created by Praveen Kumar on 8/4/12.
//  Copyright (c) 2012 InfZen, Inc. All rights reserved.
//

#import "IZCalculatorBrainTests.h"
#import "IZCalculatorBrain.h"

@interface IZCalculatorBrainTests()
@property(nonatomic, readonly, strong) IZCalculatorBrain *brain;
@end

@implementation IZCalculatorBrainTests

@synthesize brain = _brain;

- (IZCalculatorBrain *)brain
{
    if (!_brain) {
        _brain = [[IZCalculatorBrain alloc] init];
    }
    return _brain;
}

- (double)doubleValueOfOperation:(NSString *)operation
{
    return [[self.brain performOperation:operation] doubleValue];
}

// Tests begin here.

- (void)testAdd
{
    [self.brain pushOperand:9];
    [self.brain pushOperand:3];
    STAssertEquals([self doubleValueOfOperation:@"+"], 12., nil);
}

- (void)testAddWithNoOperand
{
    STAssertEquals([self doubleValueOfOperation:@"+"], 0., nil);
}

- (void)testAddWithOneOperand
{
    [self.brain pushOperand:8];
    STAssertEquals([self doubleValueOfOperation:@"+"], 8., nil);
}

- (void)testSubtract
{
    [self.brain pushOperand:9];
    [self.brain pushOperand:3];
    STAssertEquals([self doubleValueOfOperation:@"-"], 6., nil);
}

- (void)testSubtractWithNoOperand
{
    STAssertEquals([self doubleValueOfOperation:@"-"], 0., nil);
}

- (void)testSubtractWithOneOperand
{
    [self.brain pushOperand:8];
    STAssertEquals([self doubleValueOfOperation:@"-"], -8., nil);
}

- (void)testDivide
{
    [self.brain pushOperand:9];
    [self.brain pushOperand:2];
    STAssertEquals([self doubleValueOfOperation:@"/"], 4.5, nil);
}

- (void)testDivideWithNoOperand
{
    STAssertEquals([self doubleValueOfOperation:@"/"], 0., nil);
}

- (void)testDivideWithOneOperand
{
    [self.brain pushOperand:8];
    STAssertEquals([self doubleValueOfOperation:@"/"], 0., nil);
}

- (void)testDivideByZero
{
    [self.brain pushOperand:9];
    [self.brain pushOperand:0];
    STAssertEqualObjects([self.brain performOperation:@"/"], @"Divide by zero", nil);
}

- (void)testMultiply
{
    [self.brain pushOperand:9];
    [self.brain pushOperand:3];
    STAssertEquals([self doubleValueOfOperation:@"*"], 27., nil);
}

- (void)testMultiplyWithNoOperand
{
    STAssertEquals([self doubleValueOfOperation:@"*"], 0., nil);
}

- (void)testMultiplyWithOneOperand
{
    [self.brain pushOperand:8];
    STAssertEquals([self doubleValueOfOperation:@"*"], 0., nil);
}

- (void)testUnknownBinaryOperation
{
    [self.brain pushOperand:9];
    [self.brain pushOperand:2];
    STAssertEquals([self doubleValueOfOperation:@"Unknown"], 0., nil);
}

- (void)testSin
{
    [self.brain pushOperand:90];
    STAssertEqualsWithAccuracy([self doubleValueOfOperation:@"sin"], 0.893997, 0.001, nil);
}

- (void)testCos
{
    [self.brain pushOperand:90];
    STAssertEqualsWithAccuracy([self doubleValueOfOperation:@"cos"], -0.4480736161, 0.001, nil);
}

- (void)testSqrt
{
    [self.brain pushOperand:2];
    STAssertEqualsWithAccuracy([self doubleValueOfOperation:@"sqrt"], 1.414213562, 0.001, nil);
}

- (void)testSqrtOfNegativeNumber
{
    [self.brain pushOperand:-9];
    STAssertEqualObjects([self.brain performOperation:@"sqrt"], @"Complex number error", nil);
}

- (void)testLog
{
    [self.brain pushOperand:10];
    STAssertEquals([self doubleValueOfOperation:@"log"], 1., nil);
}

- (void)testE
{
    STAssertEqualsWithAccuracy([self doubleValueOfOperation:@"e"], 2.71828182846, 0.001, nil);
}

- (void)testPi
{
    STAssertEqualsWithAccuracy([self doubleValueOfOperation:@"π"], 3.14159, 0.001, nil);
}

- (void)testSignChange
{
    [self.brain pushOperand:3];
    [self doubleValueOfOperation:@"+/-"];
    [self.brain pushOperand:2];
    STAssertEquals([self doubleValueOfOperation:@"*"], -6., nil);
}

- (void)testMultipleOperations
{
    [self.brain pushOperand:3];
    [self.brain pushOperand:2];
    [self.brain pushOperand:1];
    [self.brain pushOperand:4];
    STAssertEquals([self doubleValueOfOperation:@"/"], 0.25, nil);
    STAssertEquals([self doubleValueOfOperation:@"*"], 0.50, nil);
    STAssertEquals([self doubleValueOfOperation:@"+"], 3.50, nil);
}

- (void)testProgram
{
    id program = [self.brain program];
    STAssertNotNil(program, nil);
    STAssertTrue([program isKindOfClass:[NSArray class]], nil);
}

- (void)testProgramOperandsAndOperator
{
    [self.brain pushOperand:34];
    [self.brain pushOperand:55];
    STAssertEquals([self doubleValueOfOperation:@"+"], 89., nil);
    NSArray *program = (NSArray *)[self.brain program];
    STAssertEquals([program count], 3U, nil);
    STAssertEqualObjects([program objectAtIndex:0], [NSNumber numberWithDouble:34], nil);
    STAssertEqualObjects([program objectAtIndex:1], [NSNumber numberWithDouble:55], nil);
    STAssertEqualObjects([program objectAtIndex:2], @"+", nil);
}

- (void)testVariable
{
    NSArray *program = [NSArray arrayWithObjects:[NSNumber numberWithDouble:4], @"a", @"b", @"*", @"+", nil];

    NSSet *variables = [NSSet setWithObjects:@"a", @"b", nil];
    STAssertEqualObjects([IZCalculatorBrain variablesUsedInProgram:program], variables, nil);

    NSDictionary *variableValues = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithDouble:3], @"a",
                                    [NSNumber numberWithDouble:5], @"b", nil];
    double value = [[IZCalculatorBrain runProgram:program
                              usingVariableValues:variableValues] doubleValue];
    STAssertEquals(value, 19., nil);

    // Test undefined variables.
    variableValues = [NSDictionary dictionaryWithObject:[NSNumber numberWithDouble:3] forKey:@"a"];
    value = [[IZCalculatorBrain runProgram:program
                       usingVariableValues:variableValues] doubleValue];
    STAssertEquals(value, 4., nil);
}

- (void)testDescriptionOfProgramForNullaryOperators
{
    NSArray *program;
    program = [NSArray arrayWithObject:@"π"];
    STAssertEqualObjects([IZCalculatorBrain descriptionOfProgram:program], @"π", nil);
    program = [NSArray arrayWithObject:@"e"];
    STAssertEqualObjects([IZCalculatorBrain descriptionOfProgram:program], @"e", nil);
}

- (void)testDescriptionOfProgramForUnaryOperators
{
    NSArray *program;
    program = [NSArray arrayWithObjects:[NSNumber numberWithDouble:2], @"sin", nil];
    STAssertEqualObjects([IZCalculatorBrain descriptionOfProgram:program], @"sin(2)", nil);
    program = [NSArray arrayWithObjects:[NSNumber numberWithDouble:2], @"cos", nil];
    STAssertEqualObjects([IZCalculatorBrain descriptionOfProgram:program], @"cos(2)", nil);
    program = [NSArray arrayWithObjects:[NSNumber numberWithDouble:2], @"sqrt", nil];
    STAssertEqualObjects([IZCalculatorBrain descriptionOfProgram:program], @"sqrt(2)", nil);
    program = [NSArray arrayWithObjects:[NSNumber numberWithDouble:2], @"log", nil];
    STAssertEqualObjects([IZCalculatorBrain descriptionOfProgram:program], @"log(2)", nil);
    program = [NSArray arrayWithObjects:[NSNumber numberWithDouble:2], @"+/-", nil];
    STAssertEqualObjects([IZCalculatorBrain descriptionOfProgram:program], @"+/-(2)", nil);
}

- (void)testDescriptionOfProgramForBinaryOperators
{
    NSArray *program;
    program = [NSArray arrayWithObjects:[NSNumber numberWithDouble:2], [NSNumber numberWithDouble:4], @"+", nil];
    STAssertEqualObjects([IZCalculatorBrain descriptionOfProgram:program], @"2 + 4", nil);
    program = [NSArray arrayWithObjects:[NSNumber numberWithDouble:2], [NSNumber numberWithDouble:4], @"-", nil];
    STAssertEqualObjects([IZCalculatorBrain descriptionOfProgram:program], @"2 - 4", nil);
    program = [NSArray arrayWithObjects:[NSNumber numberWithDouble:2], [NSNumber numberWithDouble:4], @"*", nil];
    STAssertEqualObjects([IZCalculatorBrain descriptionOfProgram:program], @"2 * 4", nil);
    program = [NSArray arrayWithObjects:[NSNumber numberWithDouble:2], [NSNumber numberWithDouble:4], @"/", nil];
    STAssertEqualObjects([IZCalculatorBrain descriptionOfProgram:program], @"2 / 4", nil);
}

- (void)testDescriptionOfProgramForVariables
{
    NSArray *program;
    program = [NSArray arrayWithObjects:@"x", [NSNumber numberWithDouble:4], @"+", nil];
    STAssertEqualObjects([IZCalculatorBrain descriptionOfProgram:program], @"x + 4", nil);
}

- (void)testDescriptionOfProgramComplex
{
    NSArray *program;
    program = [NSArray arrayWithObjects:[NSNumber numberWithDouble:3],
               [NSNumber numberWithDouble:5], [NSNumber numberWithDouble:6],
               [NSNumber numberWithDouble:7], @"+", @"*", @"-", nil];
    STAssertEqualObjects([IZCalculatorBrain descriptionOfProgram:program], @"3 - 5 * (6 + 7)", nil);

    program = [NSArray arrayWithObjects:[NSNumber numberWithDouble:3],
               [NSNumber numberWithDouble:5], [NSNumber numberWithDouble:6],
               [NSNumber numberWithDouble:7], @"-", @"*", @"-", nil];
    STAssertEqualObjects([IZCalculatorBrain descriptionOfProgram:program], @"3 - 5 * (6 - 7)", nil);

    program = [NSArray arrayWithObjects:[NSNumber numberWithDouble:3],
               [NSNumber numberWithDouble:5], [NSNumber numberWithDouble:6],
               [NSNumber numberWithDouble:7], @"-", @"/", @"-", nil];
    STAssertEqualObjects([IZCalculatorBrain descriptionOfProgram:program], @"3 - 5 / (6 - 7)", nil);

    program = [NSArray arrayWithObjects:[NSNumber numberWithDouble:3],
               [NSNumber numberWithDouble:5], @"+", @"sqrt", nil];
    STAssertEqualObjects([IZCalculatorBrain descriptionOfProgram:program], @"sqrt(3 + 5)", nil);

    program = [NSArray arrayWithObjects:[NSNumber numberWithDouble:3], @"sqrt", @"sqrt", nil];
    STAssertEqualObjects([IZCalculatorBrain descriptionOfProgram:program], @"sqrt(sqrt(3))", nil);

    program = [NSArray arrayWithObjects:[NSNumber numberWithDouble:3], [NSNumber numberWithDouble:5], @"sqrt", @"+", nil];
    STAssertEqualObjects([IZCalculatorBrain descriptionOfProgram:program], @"3 + sqrt(5)", nil);

    program = [NSArray arrayWithObjects:@"π", @"r", @"r", @"*", @"*", nil];
    STAssertEqualObjects([IZCalculatorBrain descriptionOfProgram:program], @"π * r * r", nil);

    program = [NSArray arrayWithObjects:@"a", @"a", @"*", @"b", @"b", @"*", @"+", @"sqrt", nil];
    STAssertEqualObjects([IZCalculatorBrain descriptionOfProgram:program], @"sqrt(a * a + b * b)", nil);

    program = [NSArray arrayWithObjects:[NSNumber numberWithDouble:3], [NSNumber numberWithDouble:5], @"+", [NSNumber numberWithDouble:6], @"*", nil];
    STAssertEqualObjects([IZCalculatorBrain descriptionOfProgram:program], @"(3 + 5) * 6", nil);

    program = [NSArray arrayWithObjects:[NSNumber numberWithDouble:3], [NSNumber numberWithDouble:5], @"+", [NSNumber numberWithDouble:6], [NSNumber numberWithDouble:2], @"-", @"/", nil];
    STAssertEqualObjects([IZCalculatorBrain descriptionOfProgram:program], @"(3 + 5) / (6 - 2)", nil);
}

- (void)testDescriptionOfProgramMultipleStack
{
    NSArray *program;
    program = [NSArray arrayWithObjects:[NSNumber numberWithDouble:3], [NSNumber numberWithDouble:5], nil];
    STAssertEqualObjects([IZCalculatorBrain descriptionOfProgram:program], @"5, 3", nil);

    program = [NSArray arrayWithObjects:[NSNumber numberWithDouble:3],
               [NSNumber numberWithDouble:5], @"+", [NSNumber numberWithDouble:6],
               [NSNumber numberWithDouble:7], @"*", [NSNumber numberWithDouble:9], @"sqrt", nil];
    STAssertEqualObjects([IZCalculatorBrain descriptionOfProgram:program], @"sqrt(9), 6 * 7, 3 + 5", nil);
}

- (void)testUndo
{
    [self.brain undo];
    STAssertEqualObjects([IZCalculatorBrain descriptionOfProgram:self.brain.program], @"", nil);
    [self.brain pushOperand:909];
    [self.brain pushOperand:342];
    [self.brain undo];
    STAssertEqualObjects([IZCalculatorBrain descriptionOfProgram:self.brain.program], @"909", nil);
    [self.brain undo];
    STAssertEqualObjects([IZCalculatorBrain descriptionOfProgram:self.brain.program], @"", nil);
    [self.brain pushOperand:4];
    [self.brain pushOperand:3];
    [self doubleValueOfOperation:@"+"];
    [self.brain undo];
    STAssertEqualObjects([IZCalculatorBrain descriptionOfProgram:self.brain.program], @"3, 4", nil);
    STAssertEquals([self doubleValueOfOperation:@"+"], 7., nil);
    STAssertEqualObjects([IZCalculatorBrain descriptionOfProgram:self.brain.program], @"4 + 3", nil);
}

@end
