//
//  IZCalculatorBrain.h
//  RPNCalculator
//
//  Created by Praveen Kumar on 8/4/12.
//  Copyright (c) 2012 InfZen, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IZCalculatorBrain : NSObject

@property (readonly) id program;

+ (double)runProgram:(id)program;
+ (NSString *)descriptionOfProgram:(id)program;

- (void)pushOperand:(double)operand;
- (double)performOperation:(NSString *)operation;

@end
