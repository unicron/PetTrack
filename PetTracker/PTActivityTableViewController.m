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
        [ViewControllerHelper createDefaultActivitiesWithManagedObjectContextContext:managedObjectContext];
    }
    
    [ViewControllerHelper setRowHeightForTable:self.tableView
                                     withCount:(int)[[self.fetchedResultsController fetchedObjects] count]];
}

- (IBAction)done:(UIStoryboardSegue *)segue {
    //    PTRecordActivityViewController *vc = (PTRecordActivityViewController *)segue.sourceViewController; // get results out of vc, which I presented
    //    if (vc.returnPetActivity) {
    
    NSManagedObjectContext *context = self.managedObjectContext;
    if (context) {
        // Save the context.
        NSError *error = nil;
        if (![context save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
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
        view.pet = self.pet;
        
        Activity *activity = [self.fetchedResultsController objectAtIndexPath:[self.tableView indexPathForSelectedRow]];
        view.activity = activity;
    
    }
    
}

@end
