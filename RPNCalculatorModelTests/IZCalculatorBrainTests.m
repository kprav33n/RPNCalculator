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

// Tests begin here.

- (void)testLastOperandIsZeroWhenEmpty
{
    STAssertEquals([self.brain lastOperand], 0., nil);
}

- (void)testLastOperandAfterPushOperand
{
    [self.brain pushOperand:4];
    STAssertEquals([self.brain lastOperand], 4., nil);
}

- (void)testLastOperandAfterTwoPushOperands
{
    [self.brain pushOperand:4];
    [self.brain pushOperand:9];
    STAssertEquals([self.brain lastOperand], 9., nil);
}

- (void)testAdd
{
    [self.brain pushOperand:9];
    [self.brain pushOperand:3];
    [self.brain performBinaryOperation:IZAdd];
    STAssertEquals([self.brain lastOperand], 12., nil);
}

- (void)testAddWithNoOperandIsNoop
{
    [self.brain performBinaryOperation:IZAdd];
    STAssertEquals([self.brain lastOperand], 0., nil);
}

- (void)testAddWithOneOperandIsNoop
{
    [self.brain pushOperand:8];
    [self.brain performBinaryOperation:IZAdd];
    STAssertEquals([self.brain lastOperand], 8., nil);
}

- (void)testSubtract
{
    [self.brain pushOperand:9];
    [self.brain pushOperand:3];
    [self.brain performBinaryOperation:IZSubtract];
    STAssertEquals([self.brain lastOperand], 6., nil);
}

- (void)testSubtractWithNoOperandIsNoop
{
    [self.brain performBinaryOperation:IZSubtract];
    STAssertEquals([self.brain lastOperand], 0., nil);
}

- (void)testSubtractWithOneOperandIsNoop
{
    [self.brain pushOperand:8];
    [self.brain performBinaryOperation:IZSubtract];
    STAssertEquals([self.brain lastOperand], 8., nil);
}

- (void)testDivide
{
    [self.brain pushOperand:9];
    [self.brain pushOperand:2];
    [self.brain performBinaryOperation:IZDivide];
    STAssertEquals([self.brain lastOperand], 4.5, nil);
}

- (void)testDivideWithNoOperandIsNoop
{
    [self.brain performBinaryOperation:IZDivide];
    STAssertEquals([self.brain lastOperand], 0., nil);
}

- (void)testDivideWithOneOperandIsNoop
{
    [self.brain pushOperand:8];
    [self.brain performBinaryOperation:IZDivide];
    STAssertEquals([self.brain lastOperand], 8., nil);
}

- (void)testMultiply
{
    [self.brain pushOperand:9];
    [self.brain pushOperand:3];
    [self.brain performBinaryOperation:IZMultiply];
    STAssertEquals([self.brain lastOperand], 27., nil);
}

- (void)testMultiplyWithNoOperandIsNoop
{
    [self.brain performBinaryOperation:IZMultiply];
    STAssertEquals([self.brain lastOperand], 0., nil);
}

- (void)testMultiplyWithOneOperandIsNoop
{
    [self.brain pushOperand:8];
    [self.brain performBinaryOperation:IZMultiply];
    STAssertEquals([self.brain lastOperand], 8., nil);
}

- (void)testUnknownBinaryOperation
{
    [self.brain pushOperand:9];
    [self.brain pushOperand:2];
    [self.brain performBinaryOperation:9];
    STAssertEquals([self.brain lastOperand], 2., nil);
    [self.brain performBinaryOperation:IZAdd];
    STAssertEquals([self.brain lastOperand], 11., nil);
}

- (void)testSin
{
    [self.brain pushOperand:90];
    [self.brain performUnaryOperation:IZSin];
    STAssertEqualsWithAccuracy([self.brain lastOperand], 0.893997, 0.001, nil);
}

- (void)testCos
{
    [self.brain pushOperand:90];
    [self.brain performUnaryOperation:IZCos];
    STAssertEqualsWithAccuracy([self.brain lastOperand], -0.4480736161, 0.001, nil);
}

- (void)testSqrt
{
    [self.brain pushOperand:2];
    [self.brain performUnaryOperation:IZSqrt];
    STAssertEqualsWithAccuracy([self.brain lastOperand], 1.414213562, 0.001, nil);
}

- (void)testPi
{
    [self.brain performNullaryOperation:IZPi];
    STAssertEqualsWithAccuracy([self.brain lastOperand], 3.14159, 0.001, nil);
}

@end
