//
//  PTActivityTableViewController.m
//  PetTracker
//
//  Created by Hannemann on 4/12/14.
//  Copyright (c) 2014 Hannemann. All rights reserved.
//

#import "PTActivityTableViewController.h"
#import "StatsTableViewController.h"
#import "PetActivity+Database.h"
#import "PTRecordActivityViewController.h"
#import "Activity+Database.h"
#import "ViewControllerHelper.h"

@interface PTActivityTableViewController ()
@end


@implementation PTActivityTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    _managedObjectContext = managedObjectContext;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Activity"];
    request.predicate = nil;
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"order"
                                                              ascending:YES]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
    self.fetchedResultsController.delegate = self;
    
    NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    if (!self.fetchedResultsController || [[self.fetchedResultsController fetchedObjects] count] == 0) {
        Activity *activity = [Activity create:nil inManagedObjectContext:managedObjectContext];
        activity.name = @"Walk";
        activity.order = @0;
        activity.bgred = @0;
        activity.bggreen = @128;
        activity.bgblue = @128;
        activity.bgalpha = @0.5;
        
        activity = [Activity create:nil inManagedObjectContext:managedObjectContext];
        activity.name = @"Nap";
        activity.order = @1;
        activity.bgred = @255;
        activity.bggreen = @128;
        activity.bgblue = @0;
        activity.bgalpha = @0.5;

        activity = [Activity create:nil inManagedObjectContext:managedObjectContext];
        activity.name = @"Meal";
        activity.order = @2;
        activity.bgred = @64;
        activity.bggreen = @0;
        activity.bgblue = @128;
        activity.bgalpha = @0.5;
        
        activity = [Activity create:nil inManagedObjectContext:managedObjectContext];
        activity.name = @"Snack";
        activity.order = @3;
        activity.bgred = @128;
        activity.bggreen = @0;
        activity.bgblue = @0;
        activity.bgalpha = @0.5;
        
        activity = [Activity create:nil inManagedObjectContext:managedObjectContext];
        activity.name = @"Potty #1";
        activity.order = @4;
        activity.bgred = @25;
        activity.bggreen = @25;
        activity.bgblue = @25;
        activity.bgalpha = @0.5;
        
        activity = [Activity create:nil inManagedObjectContext:managedObjectContext];
        activity.name = @"Potty #2";
        activity.order = @5;
        activity.bgred = @0;
        activity.bggreen = @0;
        activity.bgblue = @255;
        activity.bgalpha = @0.5;
        
        activity = [Activity create:nil inManagedObjectContext:managedObjectContext];
        activity.name = @"Playtime";
        activity.order = @6;
        activity.bgred = @204;
        activity.bggreen = @102;
        activity.bgblue = @255;
        activity.bgalpha = @0.5;
        
        activity = [Activity create:nil inManagedObjectContext:managedObjectContext];
        activity.name = @"Sick";
        activity.order = @7;
        activity.bgred = @255;
        activity.bggreen = @102;
        activity.bgblue = @102;
        activity.bgalpha = @0.5;
        
        //seems like this won't work without implementing a custom transformer
//        NSData *theData = [NSKeyedArchiver archivedDataWithRootObject:[UIColor blackColor]];
//        UIColor *theColor = (UIColor *)[NSKeyedUnarchiver unarchiveObjectWithData:theData];

        // Save the context.
        if (![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    
    [ViewControllerHelper setRowHeightForTable:self.tableView
                                     withCount:[[self.fetchedResultsController fetchedObjects] count]];
}

- (IBAction)done:(UIStoryboardSegue *)segue {
    PTRecordActivityViewController *vc = (PTRecordActivityViewController *)segue.sourceViewController; // get results out of vc, which I presented
    
    NSManagedObjectContext *context = self.managedObjectContext;
    PetActivity *petActivity = [PetActivity create:nil inManagedObjectContext:context];
    
    petActivity.pet = vc.pet;
    petActivity.activity = vc.activity;
    petActivity.date = vc.returnDate;
    
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Activity Cell" forIndexPath:indexPath];
    Activity *activity = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    // Configure the cell...
    UIColor *cellColor = [[UIColor alloc] initWithRed:activity.bgred.floatValue / 255
                                                green:activity.bggreen.floatValue / 255
                                                 blue:activity.bgblue.floatValue / 255
                                                alpha:activity.bgalpha.floatValue];
    
    cell.backgroundColor = cellColor;
    for ( UIView* view in cell.contentView.subviews )
    {
        view.backgroundColor = [ UIColor clearColor ];
    }
    
    cell.textLabel.text = activity.name;
    
    return cell;
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[PTRecordActivityViewController class]]) {
        PTRecordActivityViewController *view = (PTRecordActivityViewController *)segue.destinationViewController;
        view.managedObjectContext = self.managedObjectContext;
        view.pet = self.pet;
        
        Activity *activity = [self.fetchedResultsController objectAtIndexPath:[self.tableView indexPathForSelectedRow]];
        view.activity = activity;
    
    }
    
}

@end
