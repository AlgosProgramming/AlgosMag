
//
//  MagMasterViewController.m
//  vttt
//
//  Created by Grails on 24/08/12.
//  Copyright (c) 2012 algos. All rights reserved.
//marco


#import "MagMasterViewController.h"
#import "MagDetailViewController.h"
#import "Articolo.h"

@interface MagMasterViewController ()
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

static BOOL mostraIcone = false;
static BOOL vistaDB = FALSE;
static BOOL vistaArticoli = NO;
static BOOL vistaArticoliDB = YES;
static BOOL vistaArticoliDbInCategory = YES;
static BOOL debugMode = NO;

static BOOL alfabeticOrder;
static NSString * typeList;
static BOOL mostraTotaleArticloli;

static NSString * const NamePlist = @"articoli";
static NSString * const CellIdentifier = @"Cell";


@implementation MagMasterViewController

@synthesize articoliAz;
@synthesize typeListButton;
@synthesize changeTypeListButton;
@synthesize dicArticoli;
@synthesize category;
@synthesize db;

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    
    // Titolo della colonna di sinistra
    self.navigationItem.title = NSLocalizedString(@"Lista", @"Lista");
    
    // Setting of Segmented Control
    [self setSegmentedControl]; 

    //Only iPhone
    [typeListButton setTitle:@"+"];
    
    if (alfabeticOrder) {
        [self regolaVista:alfabeticOrder];

    } else {
        
        [self inizializza];
    }
    
    //[self inizializzaArticolo];

    [self openDB];

    //-- Creo e Riempio la tabella Articoli con 3 oggetti.
    [self insertDefaultArticles];
    
    [self getAllRowsFromArticoli];
    
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    self.detailViewController = (MagDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
 
    //****************
    /*
    NSMutableArray *listaOggetti = [[NSMutableArray alloc] init];
	
	NSArray *arrayAnimali = [NSArray arrayWithObjects:@"Cane", @"Gatto", @"Coniglio", @"Criceto", @"Cavallo", nil];
	NSDictionary *dictAnimali = [NSDictionary dictionaryWithObject:arrayAnimali forKey:@"Elementi"];
    
	NSArray *arrayOggetti = [NSArray arrayWithObjects:@"Armadio", @"Pentola", @"Ruota", @"iPhone", nil];
	NSDictionary *dictOggetti = [NSDictionary dictionaryWithObject:arrayOggetti forKey:@"Elementi"];
	
	NSArray *arrayNomi = [NSArray arrayWithObjects:@"Mario", @"Nicole", @"Simona", @"Daniel", @"Francesco", nil];
	NSDictionary *dictNomi = [NSDictionary dictionaryWithObject:arrayNomi forKey:@"Elementi"];
	
	[listaOggetti addObject:dictAnimali];
	[listaOggetti addObject:dictOggetti];
	[listaOggetti addObject:dictNomi];
	
	NSMutableArray *listaDettaglioOggetti = [[NSMutableArray alloc] init];
	
	NSArray *arrayDettaglioAnimali = [NSArray arrayWithObjects:@"Animale 1", @"Animale 2", @"Animale 3", @"Animale 4", @"Animale 5", nil];
	NSDictionary *dictDettaglioAnimali = [NSDictionary dictionaryWithObject:arrayDettaglioAnimali forKey:@"dettaglioElementi"];
	
	NSArray *arrayDettaglioOggetti = [NSArray arrayWithObjects:@"Oggetto 1", @"Oggetto 2", @"Oggetto 3", @"Oggetto 4", nil];
	NSDictionary *dictDettaglioOggetti = [NSDictionary dictionaryWithObject:arrayDettaglioOggetti forKey:@"dettaglioElementi"];
	
	NSArray *arrayDettaglioNomi = [NSArray arrayWithObjects:@"Nome 1", @"Nome 2", @"Nome 3", @"Nome 4", @"Nome 5", nil];
	NSDictionary *dictDettaglioNomi = [NSDictionary dictionaryWithObject:arrayDettaglioNomi forKey:@"dettaglioElementi"];
	
	[listaDettaglioOggetti addObject:dictDettaglioAnimali];
	[listaDettaglioOggetti addObject:dictDettaglioOggetti];
	[listaDettaglioOggetti addObject:dictDettaglioNomi];
     */
    
}

- (void)viewDidUnload
{
    [self setTypeListButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (alfabeticOrder) {
        
        if (!vistaArticoli) {
            [self regolaVista:alfabeticOrder];

        }
        return 1;
    }
    else {
        
        return [self.categoryArticoli count];
    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (alfabeticOrder) {
        
        return [articoliAz count];
    }
    else {
        
        NSString * categoryTemp = [self.categoryArticoli objectAtIndex:section];
        NSArray *articoliTemp = [self.articoli objectForKey:categoryTemp];
        return [articoliTemp count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (alfabeticOrder && vistaArticoli) {

            Articolo *art = [articoliAz objectAtIndex:indexPath.row];
            cell.textLabel.text = [art code];
    }
    
    else if (alfabeticOrder)
        cell.textLabel.text = [articoliAz objectAtIndex:indexPath.row];

    else {
        
        NSString *categoryTemp = [self.categoryArticoli objectAtIndex:[indexPath section]];
        NSArray *articoliTemp = [self.articoli objectForKey:categoryTemp];
        
        cell.textLabel.text = [articoliTemp objectAtIndex:[indexPath row]];
    }
    
    //--- Mostra Icone
    if (mostraIcone) {
        
        [self setCellWithDefaultImageWithCell:cell indexPath:indexPath];
    }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        NSError *error = nil;
        if (![context save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }   
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        
        if (!self.detailViewController) {
            
            self.detailViewController = [[MagDetailViewController alloc] initWithNibName:@"MagDetailViewController" bundle:nil];;
        }
        //self.detailViewController.detailItem = [NSString stringWithFormat:@"%@", [dicArticoli objectAtIndex:indexPath.row]];
        
        if (articoliAz) {
            if (vistaArticoli) {
  
                Articolo *art = [articoliAz objectAtIndex:indexPath.row];
                //-- Disabilito l'editing x i textField
                [self.detailViewController.codeTextField setEnabled:NO];
                [self.detailViewController.nameTextField setEnabled:NO];
                [self.detailViewController.categoryTextField setEnabled:NO];
                [self.detailViewController.descritpionTextField setEnabled:NO];
                [self.detailViewController.priceTextField setEnabled:NO];

                //-- Riempio i textField.
                self.detailViewController.codeTextField.text = [NSString stringWithFormat:@"%@", [art code]];
                self.detailViewController.nameTextField.text = [NSString stringWithFormat:@"%@", [art name]];
                self.detailViewController.categoryTextField.text = [NSString stringWithFormat:@"%@", [art category]];
                self.detailViewController.descritpionTextField.text = [NSString stringWithFormat:@"%@", [art description]];
                self.detailViewController.priceTextField.text = [NSString stringWithFormat:@"%@",[art price]];


            }
            else
                self.detailViewController.detailItem = [NSString stringWithFormat:@"%@", [articoliAz objectAtIndex:indexPath.row]];

        }
        else {
            
            NSString *categoryTemp = [self.categoryArticoli objectAtIndex:indexPath.section];
            NSArray *articoliTemp = [self.articoli objectForKey:categoryTemp];
            NSObject *obj = [articoliTemp objectAtIndex:indexPath.row];
            self.detailViewController.detailItem = [NSString stringWithFormat:@"%@", obj];
        }
        
        //[dicArticoli objectForKey:indexPath.section];
       // self.detailViewController.detailItem = @"";
        //NSObject *obj= [NSString stringWithFormat:@"%@", [articoliAz objectAtIndex:indexPath.section]];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSManagedObject *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        [[segue destinationViewController] setDetailItem:object];
    }
}

//--display the header--
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    if (alfabeticOrder) {
        
        return @"Lista articoli";
    } else {
        
        NSString *categoryTemp = [self.categoryArticoli objectAtIndex:section];
        NSArray *articoliTemp = [self.articoli objectForKey:categoryTemp];

        //--- Se nella Sezione non ci sono articoli, non la mostro.
        if (articoliTemp.count == 0) {
            
            categoryTemp = @"";
        }
        
        return categoryTemp;

    }
}


//--display the footer--
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    
    if (alfabeticOrder & mostraTotaleArticloli) {
        NSInteger articoliNum = [articoliAz count];
        return[[NSString alloc] initWithFormat:@"Nel magazzino ci sono %d articoli", articoliNum];

    } else {
        return nil;
    }
}

//--display della singola cella--
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    //if (indexPath.row == 0 || indexPath.row%2 == 0) {
        
        //UIColor *altCellColor = [UIColor colorWithWhite:0.3 alpha:0.2];
        //cell.backgroundColor = altCellColor;
    //}
}

//--indenting each row--
//--non funziona--
- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [indexPath row] % 2;
}


//--heiht of each row--
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
    //return 40 + 30 * ([indexPath row] % 2);
}

#pragma mark - Change List Methods

- (void)toggleTypeListButton {
    UIImage* icon;
    
    if (alfabeticOrder) {
        
        icon = [UIImage imageNamed:@"Ukraine.png"];
        [typeListButton setTitle:@"+"];
        [self regolaVista:TRUE];
        alfabeticOrder = FALSE;
    } else {
        
        icon = [UIImage imageNamed:@"Romania.png"];
        [typeListButton setTitle:@"-"];
        [self regolaVista:FALSE];
        alfabeticOrder = TRUE;
    }
    
    //Fa il refresh
    [self.tableView reloadData];
    //[typeListButton setImage:icon];
}

- (void)regolaVista:(BOOL)alfabetic {
    
    if (alfabetic) {
        
        self.articoliAz = [self listaArticoli];
        self.dicArticoli = nil;
        self.category = nil;
        
        /*if (vistaArticoli)
            [self inizializzaArticolo];
        */
        if (vistaDB)
            self.articoliAz = [self viewDB];
    }
    else {
        
        self.articoliAz = nil;
        self.dicArticoli = [self getDictionaryArticoli];
        self.category = [[self.dicArticoli allKeys] sortedArrayUsingSelector:@selector(compare:)];
    }
}


- (void)regolaVistaDB:(BOOL)alfabetic {
    
    if (alfabetic) {
        
        self.articoliAz = [self listaArticoli];
        self.dicArticoli = nil;
        self.category = nil;
        
        /*if (vistaArticoli)
         [self inizializzaArticolo];
         */
        if (vistaDB)
            self.articoliAz = [self viewDB];
    }
    else {
        
        self.articoliAz = nil;
        self.dicArticoli = [self creaVistaCategoryWithArray:[self getAllArticoli]];
        self.category = [[self.dicArticoli allKeys] sortedArrayUsingSelector:@selector(compare:)];
    }
}

- (IBAction)pressChageTypeListButton:(id)sender {
        
    [self chageViewOrderWithPosition:[self.changeTypeListButton selectedSegmentIndex]];

}

- (void)chageViewOrderWithPosition:(int)posizione{
    
    switch (posizione)  {
        case 0:
            
            alfabeticOrder = TRUE;
            vistaDB = FALSE;
            vistaArticoli = NO;
            [self regolaVista:alfabeticOrder];

            break;
            
        case 1:
            
            alfabeticOrder = FALSE;
            vistaArticoli = NO;
            [self regolaVista:alfabeticOrder];
            break;
            
            
        case 2:
            
            [self case2Method];
            if (vistaArticoliDbInCategory) {
                alfabeticOrder = FALSE;
                vistaArticoli = FALSE;
                [self regolaVista:alfabeticOrder];

            }
            break;
            
        default:
            break;
    }
    
    [self.tableView reloadData];
}

- (void)case2Method {
    if (debugMode) {
        if (vistaArticoliDB) {
            
            [self inizializzaArticoloFromDB];
        }
        
        [self inizializzaArticolo];
        
    }
    else {
        
        [self initFromDB];
    }
    alfabeticOrder = TRUE;
    vistaArticoli = YES;

    
}

- (NSArray *)viewDB {
    
    NSString * qsql = [NSString stringWithFormat:@"SELECT * FROM %@", @"pippo"];
    sqlite3_stmt *statment;
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    if (sqlite3_prepare_v2(self.db, [qsql UTF8String], -1, &statment, nil) == SQLITE_OK) {
        
        while (sqlite3_step(statment) == SQLITE_ROW) {
            
            char *field1 = (char *) sqlite3_column_text(statment, 1);
            NSString *field1Str = [[NSString alloc] initWithUTF8String:field1];
            
            NSString *str = [[NSString alloc] initWithFormat:@"%@", field1Str];
            NSLog(@"%@", str);
            [array addObject:str];
        }
        //-- Delete the compiler statment from memory
        sqlite3_finalize(statment);
    }
    
    
    return array;
}


- (IBAction)pressTypeListButton:(id)sender {
    
    [self toggleTypeListButton];
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"sigla" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
	     // Replace this implementation with code to handle the error appropriately.
	     // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return _fetchedResultsController;
}    

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

/*
// Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed. 
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    // In the simplest, most efficient, case, reload the table view.
    [self.tableView reloadData];
}
 */

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [[object valueForKey:@"sigla"] description];
}

//--adding indexing--

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    [tempArray addObject:@"1"];
    [tempArray addObject:@"2"];
    [tempArray addObject:@"3"];
    [tempArray addObject:@"4"];
    [tempArray addObject:@"5"];
    [tempArray addObject:@"6"];

    //--solo se la lista è lunga--
    if ([articoliAz count]>30) {
        return tempArray;
    } else {
        return nil;
    }
}




#pragma mark - Plist Methods

//--- lista articoli in ordine alfabetico
//--- legge dictionary
//--- crea lista articoli

- (NSArray *)listaArticoli {
    static NSString *namePlist = @"articoli";
    
    //--- legge dictionary
    NSDictionary *dictionary = [self dictionaryWithString:namePlist];
    
    //NSArray *arrayKeys = [[self.categorieMerceologiche allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    //--- crea lista articoli
   NSArray *listaArticoli = [self articoliFromDictionary:dictionary];

    //--- ordina in modo alfabetico
    listaArticoli = [listaArticoli sortedArrayUsingSelector:@selector(compare:)];

    return listaArticoli;

}

- (NSArray *)articoliFromDictionary:(NSDictionary *)dictionary {
    
    NSMutableArray *listaTemp = [[NSMutableArray alloc] init];
    for (id key in dictionary) {
        
        id value = [dictionary objectForKey:key];
        
        for (id riga in value) {
            
            id stringa = (NSString *)riga;
            NSLog(@"Stringa = '%@'", stringa);
            [listaTemp addObject:stringa];
        }
    }
    return [[NSArray alloc] initWithArray:listaTemp];
}

- (NSDictionary *)dictionaryWithString:(NSString *)name {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"plist"];
    NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    return dictionary;
}

- (NSDictionary *)getDictionaryArticoli {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"articoli" ofType:@"plist"];
    NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    return dictionary;

}

#pragma mark - Settings Mehods

- (void)loadSettings {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    alfabeticOrder = [self convertIntegerToBoolean:[defaults objectForKey:@"alfabeticOrder"]];
    mostraTotaleArticloli = [self convertIntegerToBoolean:[defaults objectForKey:@"mostraTotaleArticoli"]];
    typeList = [defaults objectForKey:@"sezioni"];
}

- (BOOL)convertIntegerToBoolean:(id)integerValue {
    
    return [integerValue boolValue];

}
#pragma mark - Init Methods

- (void)setSegmentedControl {
    
    //--- Abilito il click su tutti i bottoni del Segmented Control
    [self.changeTypeListButton setEnabled:YES forSegmentAtIndex:0];
    [self.changeTypeListButton setEnabled:YES forSegmentAtIndex:1];
    [self.changeTypeListButton setEnabled:YES forSegmentAtIndex:2];

    //--- Inserisco i titoli su tutti i bottini del Segmented Control
    [self.changeTypeListButton setTitle:@"Az" forSegmentAtIndex:0];
    [self.changeTypeListButton setTitle:@"Category" forSegmentAtIndex:1];
    [self.changeTypeListButton setTitle:@"Articoli" forSegmentAtIndex:2];
    
    //--- Dico quale section selezione in base alla fista di default
    switch (alfabeticOrder) {
        case TRUE:
            
            [self.changeTypeListButton setSelectedSegmentIndex:0];
            break;
            
        case FALSE:
            
            [self.changeTypeListButton setSelectedSegmentIndex:1];
            break;
            
        default:
            
            [self.changeTypeListButton setSelectedSegmentIndex:2];
            break;
    }
}

- (void)inizializza {
    
    //Prendo il path della mia plist
    NSString *path = [[NSBundle mainBundle] pathForResource:NamePlist ofType:@"plist"];
    
    //--- Prendo tutti gli articoli.
    NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:path]; 
    self.articoli = dic;
    
    //--- Prendo tutte le CATEGORY
    NSArray *array = [[self.articoli allKeys] sortedArrayUsingSelector:@selector(compare:)];
    self.categoryArticoli = array;
    

}

- (UITableViewCell *)setCellWithDefaultImageWithCell :(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath {
    
    UIImage *image;
    switch (indexPath.row) {
        case 1:
            image = [UIImage imageNamed:@"Ukraine.png"];
            break;
        case 2:
            image = [UIImage imageNamed:@"Brazil.png"];
            break;
        case 3:
            image = [UIImage imageNamed:@"Switzerland.png"];
            break;
            
        default:
            image = [UIImage imageNamed:@"Belgium.png"];
            break;
    }
    cell.imageView.image = image;
    return cell;
}

#pragma mark - Database Methods

- (void) insertDefaultArticles {
    
    [self createTableNamed:@"Articoli" withCode:@"code" withName:@"name" withCateogry:@"category" withDescription:@"description" withPrice:@"price"];
    
    [self insertRecordIntoNamed:@"Articoli" codeValue:@"001" nameValue:@"Rossa" categoryValue:@"Vernici" descriptionValue:@"Vernice Rossa" priceValue:@"54€"];
    [self insertRecordIntoNamed:@"Articoli" codeValue:@"002" nameValue:@"Verde" categoryValue:@"Vernici" descriptionValue:@"Vernice Verde" priceValue:@"90€"];
    [self insertRecordIntoNamed:@"Articoli" codeValue:@"003" nameValue:@"Gialla" categoryValue:@"Vernici" descriptionValue:@"Vernice Gialla" priceValue:@"110€"];
    
    [self insertRecordIntoNamed:@"Articoli" codeValue:@"004" nameValue:@"Gialla" categoryValue:@"Cacca" descriptionValue:@"Vernice Gialla" priceValue:@"110€"];
    
    [self insertRecordIntoNamed:@"Articoli" codeValue:@"005" nameValue:@"Gialla" categoryValue:@"Puppu" descriptionValue:@"Vernice Gialla" priceValue:@"110€"];
    
}

- (NSString *) filePath {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    
    return [documentsDir stringByAppendingPathComponent:@"database.sql"];
}

- (void) openDB {
    
    //-- Create Database --
    if (sqlite3_open([[self filePath] UTF8String], &db) != SQLITE_OK) {
        
        sqlite3_close(self.db);
        NSLog(@"Database falied to open.");
    }
}

- (void)createTableNamed:(NSString *)tableName withField1:(NSString *)field1 withField2:(NSString *)field2 {
    
    char *err;
    NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' "
                     "TEXT PRIMARY KEY, '%@' TEXT);", tableName, field1, field2];
    
    if (sqlite3_exec(self.db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        
        sqlite3_close(self.db);
        NSLog(@"Database falied create.");
    }
}

- (void)createTableNamed:(NSString *)tableName withCode:(NSString *)code withName:(NSString *)name withCateogry:(NSString *)cateogry withDescription:(NSString *)descritpion withPrice:(NSString *)price;{
    
    char *err;
    NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' "
                     "TEXT PRIMARY KEY, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT);", tableName, code, name, cateogry, descritpion, price];
    
    if (sqlite3_exec(self.db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        
        sqlite3_close(self.db);
        NSLog(@"Database falied create.");
    }
}

- (void) insertRecordIntoNamed:(NSString *)tableName withField1:(NSString *)field1 field1Value:(NSString *)field1Value andField2:(NSString *)field2 field2Value:(NSString *)field2Value {
    
    NSString *sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO '%@' ('%@', '%@') "
                     "VALUES ('%@','%@')", tableName, field1, field2, field1Value, field2Value];
    
    
    char *err;
    if (sqlite3_exec(self.db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        
        sqlite3_close(self.db);
        NSLog(@"Error Updating table. '%s'", err);
    }
}

- (void) insertRecordIntoNamed:(NSString *)tableName codeValue:(NSString *)codeValue nameValue:(NSString *)nameValue categoryValue:(NSString *)categoryValue descriptionValue:(NSString *)descriptionValue priceValue:(NSString *)priceValue {
    
    NSString *sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO '%@' ('code', 'name', 'category', 'description', 'price') "
                     "VALUES ('%@','%@','%@','%@','%@')", tableName, codeValue, nameValue, categoryValue, descriptionValue, priceValue];
    
    
    char *err;
    if (sqlite3_exec(self.db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        
        sqlite3_close(self.db);
        NSLog(@"Error Updating table. '%s'", err);
    }
}


- (void) insertRecordInPippoWithfield1Value:(NSString *)field1Value field2Value:(NSString *)field2Value
{
    
    [self insertRecordIntoNamed:@"pippo" withField1:@"code" field1Value:field1Value andField2:@"name" field2Value:field2Value];
}

- (void)insertArticoliInDbIntoNamed:(NSString *)tableName {
    
    [self createTableNamed:tableName withField1:@"code" withField2:@"name"];
    
    [self insertRecordInPippoWithfield1Value:@"001" field2Value:@"Red"];
    [self insertRecordInPippoWithfield1Value:@"002" field2Value:@"Blue"];
    [self insertRecordInPippoWithfield1Value:@"003" field2Value:@"Green"];

    [self getObjectFromTableName:tableName];
    
    
}

- (void)PROVAinsertArticoliInDbIntoNamed:(NSString *)tableName favlue:(NSString *)ff {
    
    [self createTableNamed:tableName withField1:@"code" withField2:@"name"];
    
    [self insertRecordInPippoWithfield1Value:@"001" field2Value:@"Red"];
    [self insertRecordInPippoWithfield1Value:@"002" field2Value:@"Blue"];
    [self insertRecordInPippoWithfield1Value:@"003" field2Value:@"Green"];
    [self insertRecordInPippoWithfield1Value:@"003" field2Value:ff];
    [self getObjectFromTableName:tableName];


}
- (void)getObjectFromTableName:(NSString *)tableName {
    
    NSString * qsql = [NSString stringWithFormat:@"SELECT * FROM %@", tableName];
    sqlite3_stmt *statment;

    if (sqlite3_prepare_v2(self.db, [qsql UTF8String], -1, &statment, nil) == SQLITE_OK) {
        
        while (sqlite3_step(statment) == SQLITE_ROW) {
            
            char *field1 = (char *) sqlite3_column_text(statment, 1);
            NSString *field1Str = [[NSString alloc] initWithUTF8String:field1];
            
            NSString *str = [[NSString alloc] initWithFormat:@"%@", field1Str];
            NSLog(@"%@", str);
            
        }
        
        //-- Delete the compiler statment from memory
        sqlite3_finalize(statment);
    }
}





- (void)getAllRowsFromTableNamed:(NSString *)tableName {
    
    NSString * qsql = [NSString stringWithFormat:@"SELECT * FROM %@", tableName];
    sqlite3_stmt *statment;
    if (sqlite3_prepare_v2(self.db, [qsql UTF8String], -1, &statment, nil) == SQLITE_OK) {
        
        while (sqlite3_step(statment) == SQLITE_ROW) {
            
            char *field1 = (char *) sqlite3_column_text(statment, 0);
            NSString *field1Str = [[NSString alloc] initWithUTF8String:field1];
            
            char *field2 = (char *) sqlite3_column_text(statment, 1);
            NSString *field2Str = [[NSString alloc] initWithUTF8String:field2];
            
            NSString *str = [[NSString alloc] initWithFormat:@"%@ - %@", field1Str, field2Str];
            NSLog(@"%@", str);
            
        }
        
        //-- Delete the compiler statment from memory
        sqlite3_finalize(statment);
    }
}

- (void)getAllRowsFromArticoli {
    
    NSString * qsql = [NSString stringWithFormat:@"SELECT * FROM Articoli"];
    sqlite3_stmt *statment;
    if (sqlite3_prepare_v2(self.db, [qsql UTF8String], -1, &statment, nil) == SQLITE_OK) {
        
        while (sqlite3_step(statment) == SQLITE_ROW) {
            
            char *field1 = (char *) sqlite3_column_text(statment, 0);
            NSString *field1Str = [[NSString alloc] initWithUTF8String:field1];
            
            char *field2 = (char *) sqlite3_column_text(statment, 1);
            NSString *field2Str = [[NSString alloc] initWithUTF8String:field2];
            
            char *field3 = (char *) sqlite3_column_text(statment, 2);
            NSString *field3Str = [[NSString alloc] initWithUTF8String:field3];

            char *field4 = (char *) sqlite3_column_text(statment, 3);
            NSString *field4Str = [[NSString alloc] initWithUTF8String:field4];

            char *field5 = (char *) sqlite3_column_text(statment, 4);
            NSString *field5Str = [[NSString alloc] initWithUTF8String:field5];

            
            NSString *str = [[NSString alloc] initWithFormat:@"%@ - %@ - %@ - %@ - %@", field1Str, field2Str, field3Str, field4Str, field5Str];
            NSLog(@"%@", str);
            
        }
        
        //-- Delete the compiler statment from memory
        sqlite3_finalize(statment);
    }
}

- (NSArray *)getAllArticoli {
    
    NSString * qsql = [NSString stringWithFormat:@"SELECT * FROM Articoli"];
    sqlite3_stmt *statment;
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    if (sqlite3_prepare_v2(self.db, [qsql UTF8String], -1, &statment, nil) == SQLITE_OK) {
        
        while (sqlite3_step(statment) == SQLITE_ROW) {
            Articolo *art = [[Articolo alloc] init];

            char *field1 = (char *) sqlite3_column_text(statment, 0);
            NSString *field1Str = [[NSString alloc] initWithUTF8String:field1];
            
            char *field2 = (char *) sqlite3_column_text(statment, 1);
            NSString *field2Str = [[NSString alloc] initWithUTF8String:field2];
            
            char *field3 = (char *) sqlite3_column_text(statment, 2);
            NSString *field3Str = [[NSString alloc] initWithUTF8String:field3];
            
            char *field4 = (char *) sqlite3_column_text(statment, 3);
            NSString *field4Str = [[NSString alloc] initWithUTF8String:field4];
            
            char *field5 = (char *) sqlite3_column_text(statment, 4);
            NSString *field5Str = [[NSString alloc] initWithUTF8String:field5];
            
            [art setCode:field1Str];
            [art setName:field2Str];
            [art setCategory:field3Str];
            [art setDescription:field4Str];
            
            [tempArray addObject:(Articolo *)art];
            NSString *str = [[NSString alloc] initWithFormat:@"%@ - %@ - %@ - %@ - %@", field1Str, field2Str, field3Str, field4Str, field5Str];
            NSLog(@"%@", str);
            
        }
        [self creaVistaCategoryWithArray:tempArray];
        
        //-- Delete the compiler statment from memory
        sqlite3_finalize(statment);
    }
    return tempArray;
}



#pragma mark - Articolo Methos

//-- Per vista Alfabetica
- (void)inizializzaArticolo {
    
    Articolo *art = [[Articolo alloc] init];
    [art setCode:@"Codice"];
    [art setName:@"Nome"];
     
    NSArray *articoli = [[NSArray alloc] initWithObjects:art, nil];
    self.articoliAz = articoli;

}

- (void)initFromDB {
    
    NSArray *array = [[NSArray alloc] init];
    array = [self getAllArticoli];
    self.articoliAz = array;
    
}

- (void)inizializzaArticoloFromDB {
    
    Articolo *art = [[Articolo alloc] init];
    
    NSArray *array = [[NSArray alloc] init];
    array = [self getAllArticoli];

    art = [array objectAtIndex:0];
    art = [array objectAtIndex:1];
}

#pragma mark - Temporaneamente Disabilitati

//Temporanemente disabilitato - serve x cambiare il tipo di lista
- (void)loadView2 {
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame] style:UITableViewStyleGrouped];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView reloadData];
    self.view = tableView;
    //self.tableView = tableView;
}

- (void)ViewWillAppear:(BOOL)animated {
    
    [self loadSettings];
    
    if (alfabeticOrder) {
        NSLog(@"+++ TRUE");
    } else {
        NSLog(@"--- FALSE");
    }
}

- (void)insertNewObject:(id)sender
{
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    
    // If appropriate, configure the new managed object.
    // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
    // [newManagedObject setValue:[NSDate date] forKey:@"timeStamp"];
    [newManagedObject setValue:[NSString string] forKey:@"stringa"];
    
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

- (NSDictionary *)creaVistaCategoryWithArray:(NSArray *)array {
    NSArray *categoryArray = [[NSArray alloc] init];
    NSMutableDictionary *articoliDictionary = [[NSMutableDictionary alloc] init];
    categoryArray = [self categoryFromArray:array];  
    
    for (int i = 0; i < categoryArray.count; i++) {
        
        NSString *categoryTemp = [[NSString alloc] init];
        NSMutableArray *arrayTemp = [[NSMutableArray alloc] init];
        categoryTemp = [categoryArray objectAtIndex:i];
        
        for (int y = 0; y < array.count; y++) {
            
            Articolo *art = [[Articolo alloc] init];
            art = [array objectAtIndex:y];
            
            if ([categoryTemp isEqualToString:art.category]) {
                
                [arrayTemp addObject:art];
            }//end if
        }//end for
        
        [articoliDictionary setObject:arrayTemp forKey:categoryTemp];
    }//end for
    
    return articoliDictionary;
}

- (BOOL)categoryAlreadyExistWithString:(NSString *)categoria withArray:(NSArray *)array {
    
    for (NSString *tempString in array) {
        
        if ([categoria isEqualToString:tempString]) {
            return TRUE;
        }
    }
    return FALSE;
}

- (NSArray *)categoryFromArray:(NSArray *)array {
    
    NSMutableArray *categoryArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < array.count; i++) {
        
        Articolo *art = [[Articolo alloc] init];
        NSString *tempString = [[NSString alloc] init];
        
        art = [array objectAtIndex:i];
        tempString = [art category];
        
        if (![self categoryAlreadyExistWithString:tempString withArray:categoryArray]) {
            
            [categoryArray addObject:tempString];
        }
    }
    
    return categoryArray;
}

- (NSArray *)categoryDuplicateFromArray:(NSArray *)array {
    
    NSMutableArray *categoryArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < array.count; i++) {
        
        Articolo *art = [[Articolo alloc] init];
        NSString *tempString = [[NSString alloc] init];
        
        art = [array objectAtIndex:i];
        tempString = [art category];

        [categoryArray addObject:tempString];
    }
    
    return categoryArray;
}





@end
