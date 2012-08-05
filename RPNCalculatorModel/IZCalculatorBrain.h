//
//  IZCalculatorBrain.h
//  RPNCalculator
//
//  Created by Praveen Kumar on 8/4/12.
//  Copyright (c) 2012 InfZen, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    IZPi,
} IZNullaryOperation;

typedef enum {
    IZSin,
    IZCos,
    IZSqrt,
} IZUnaryOperation;

typedef enum {
    IZAdd,
    IZSubtract,
    IZDivide,
    IZMultiply,
} IZBinaryOperation;

@interface IZCalculatorBrain : NSObject

- (double)lastOperand;
- (void)pushOperand:(double)operand;
- (void)performNullaryOperation:(IZNullaryOperation)operation;
- (void)performUnaryOperation:(IZUnaryOperation)operation;
- (void)performBinaryOperation:(IZBinaryOperation)operation;
- (void)clear;

// These exist for unit testing only.
- (NSUInteger)operandsCount;

@end
