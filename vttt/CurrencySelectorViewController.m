
//
//  CurrencySelectorViewController.m
//  vttt
//
//  Created by Marco Velluto on 30/08/12.
//  Copyright (c) 2012 Marco Velluto. All rights reserved.
//

#import "CurrencySelectorViewController.h"

@interface CurrencySelectorViewController ()

@end

@implementation CurrencySelectorViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
