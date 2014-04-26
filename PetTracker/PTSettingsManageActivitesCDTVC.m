//
//  PTSettingsManageActivitesCDTVC.m
//  PetTracker
//
//  Created by Hannemann on 4/16/14.
//  Copyright (c) 2014 Hannemann. All rights reserved.
//

#import "PTSettingsManageActivitesCDTVC.h"
#import "Activity+Database.h"
#import "ViewControllerHelper.h"
#import "PTSettingsActivityViewController.h"

@interface PTSettingsManageActivitesCDTVC ()

@end

@implementation PTSettingsManageActivitesCDTVC

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
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setRowHeight];
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
    
    [self setRowHeight];
}

- (void)setRowHeight{
    [ViewControllerHelper setRowHeightForTable:self.tableView
                                     withCount:[[self.fetchedResultsController fetchedObjects] count]];
}

- (IBAction)doneActivity:(UIStoryboardSegue *)segue {
//    PTSettingsActivityViewController *view = (PTSettingsActivityViewController *)segue.sourceViewController; // get results out of vc, which I presented
//    Activity *activity = view.activity;
    
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

// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    
}

// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return NO;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[PTSettingsActivityViewController class]]) {
        PTSettingsActivityViewController *view = (PTSettingsActivityViewController *)segue.destinationViewController;
        view.managedObjectContext = self.managedObjectContext;
        
        Activity *activity = [self.fetchedResultsController objectAtIndexPath:[self.tableView indexPathForSelectedRow]];
        view.activity = activity;
    }
}

@end
