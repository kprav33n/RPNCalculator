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

@end
