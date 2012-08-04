//
//  IZCalculatorBrain.h
//  RPNCalculator
//
//  Created by Praveen Kumar on 8/4/12.
//  Copyright (c) 2012 InfZen, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    IZAdd,
    IZSubtract,
    IZDivide,
    IZMultiply,
} IZBinaryOperation;

@interface IZCalculatorBrain : NSObject

- (double)lastOperand;
- (void)pushOperand:(double)operand;
- (void)performBinaryOperation:(IZBinaryOperation)operation;

@end
