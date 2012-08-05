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

- (IBAction)digitPressed:(UIButton *)sender;
- (IBAction)enterPressed;
- (IBAction)operatorPressed:(UIButton *)sender;

@end
