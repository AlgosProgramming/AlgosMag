//
//  MagAggiungiViewController.m
//  vttt
//
//  Created by Marco Velluto on 07/09/12.
//  Copyright (c) 2012 algos. All rights reserved.
//

#import "MagAggiungiViewController.h"
#import "MagMasterViewController.h"

@interface MagAggiungiViewController ()

@end

@implementation MagAggiungiViewController
@synthesize codeTextEdit;
@synthesize nameTextEdit;

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
    [self setCodeTextEdit:nil];
    [self setNameTextEdit:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)pressButtonSave:(id)sender {
    

    MagMasterViewController *mgv = [[MagMasterViewController alloc] init];
    [mgv insertRecordInPippoWithfield1Value:codeTextEdit.text field2Value:nameTextEdit.text];
    [mgv PROVAinsertArticoliInDbIntoNamed:@"Prova" favlue:@"hghg"];
}
@end
