//
//  PTSettingsManagePetsCDTVC.m
//  PetTracker
//
//  Created by Hannemann on 4/16/14.
//  Copyright (c) 2014 Hannemann. All rights reserved.
//

#import "PTSettingsManagePetsCDTVC.h"
#import "Pet+Database.h"
#import "PTSettingsPetViewController.h"

@interface PTSettingsManagePetsCDTVC ()

@end

@implementation PTSettingsManagePetsCDTVC

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
    UIBarButtonItem *addButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                   target:self
                                                                                   action:@selector(doModal:)];
    
    self.navigationItem.rightBarButtonItems = @[self.editButtonItem, addButtonItem];
}

- (void)doModal:(id)sender {
    [self performSegueWithIdentifier:@"Add Pet" sender:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    _managedObjectContext = managedObjectContext;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Pet"];
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
    
}

- (IBAction)donePet:(UIStoryboardSegue *)segue {
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Pet Cell" forIndexPath:indexPath];
    Pet *pet = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    // Configure the cell...
    
    cell.textLabel.text = pet.name;
    cell.imageView.image = [[UIImage alloc] initWithData:pet.picture];
    
    return cell;
}

// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    // Bypass the delegates temporarily
    self.fetchedResultsController.delegate = nil;
    
    // Get a handle to the playlist we're moving
    NSMutableArray *pets = [NSMutableArray arrayWithArray:[self.fetchedResultsController fetchedObjects]];
    
    // Get a handle to the call we're moving
    Pet *petToMove = [pets objectAtIndex:fromIndexPath.row];
    
    // Remove the object from it's current position
    [pets removeObjectAtIndex:fromIndexPath.row];
    
    // Insert it at it's new position
    [pets insertObject:petToMove atIndex:toIndexPath.row];
    
    // Update the order of them all according to their index in the mutable array
    [pets enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Pet *p = (Pet *)obj;
        p.order = [NSNumber numberWithInt:(int)idx];
    }];
    
    // Save the managed object context
    NSManagedObjectContext *context = self.managedObjectContext;
    [context save:nil];
    
    // Allow the delegates to work now
    self.fetchedResultsController.delegate = self;
    
    [self.fetchedResultsController performFetch:nil];
    [tableView reloadData];
}

// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[PTSettingsPetViewController class]]) {
        PTSettingsPetViewController *view = (PTSettingsPetViewController *)segue.destinationViewController;
        view.managedObjectContext = self.managedObjectContext;
        
        Pet *pet = [self.fetchedResultsController objectAtIndexPath:[self.tableView indexPathForSelectedRow]];        
        view.pet = pet;
    }
}

@end
