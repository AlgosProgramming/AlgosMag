//
//  MagMasterViewController.h
//  vttt
//
//  Created by Grails on 24/08/12.
//  Copyright (c) 2012 algos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "sqlite3.h"
@class MagDetailViewController;


@interface MagMasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>
{
    NSArray *articoliAz;
    NSDictionary *dicArticoli;
    NSArray *category;
    UITableViewStyle style;

}

@property (assign, nonatomic)sqlite3 *db;

//-- System
@property (strong, nonatomic) MagDetailViewController *detailViewController;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

//-- Lista Alfabetica
@property (nonatomic, retain) NSDictionary *dicArticoli;
@property (nonatomic, retain) NSArray *category;
@property (nonatomic, retain) NSArray *articoliAz;


//-- Lista per categorie
@property (nonatomic, retain) NSDictionary *articoli;
@property (nonatomic, retain) NSArray *categoryArticoli;

//Style
@property (nonatomic, readonly)UITableViewStyle style;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *typeListButton;
@property (readonly, nonatomic) IBOutlet UISegmentedControl *changeTypeListButton;

- (IBAction)pressChageTypeListButton:(id)sender;
- (void)PROVAinsertArticoliInDbIntoNamed:(NSString *)tableName favlue:(NSString *)ff;


- (IBAction)pressTypeListButton:(id)sender;
- (void)toggleTypeListButton;
- (void)regolaVista:(BOOL)alfabetic;

+ (NSArray *)articoliToDictionry:(NSDictionary *)dictionary;

- (void) insertRecordInPippoWithfield1Value:(NSString *)field1Value field2Value:(NSString *)field2Value;
- (BOOL)categoryAlreadyExistWithString:(NSString *)categoria withArray:(NSArray *)array;
@end
