//
//  IZViewController.h
//  RPNCalculator
//
//  Created by Praveen Kumar on 8/4/12.
//  Copyright (c) 2012 InfZen, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IZViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *display;
@property (weak, nonatomic) IBOutlet UILabel *operationsDisplay;
@property (weak, nonatomic) IBOutlet UILabel *variablesDisplay;

// These actions are declared in the interface for unit testing.
- (IBAction)digitPressed:(UIButton *)sender;
- (IBAction)enterPressed;
- (IBAction)operatorPressed:(UIButton *)sender;
- (IBAction)decimalPressed;
- (IBAction)clearPressed;
- (IBAction)deletePressed;
- (IBAction)signChangePressed:(UIButton *)sender;
- (IBAction)variablePressed:(UIButton *)sender;
- (IBAction)testPressed:(UIButton *)sender;

@end
