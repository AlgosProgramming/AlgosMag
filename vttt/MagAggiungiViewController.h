//
//  MagAggiungiViewController.h
//  vttt
//
//  Created by Marco Velluto on 07/09/12.
//  Copyright (c) 2012 algos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MagAggiungiViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *codeTextEdit;
@property (strong, nonatomic) IBOutlet UITextField *nameTextEdit;

- (IBAction)pressButtonSave:(id)sender;
@end
