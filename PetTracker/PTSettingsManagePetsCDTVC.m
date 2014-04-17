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
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name"
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
    PTSettingsPetViewController *view = (PTSettingsPetViewController *)segue.sourceViewController; // get results out of vc, which I presented
    Pet *pet = view.pet;
    
    NSManagedObjectContext *context = self.managedObjectContext;

    if (pet) {
        // Save the context.
        NSError *error = nil;
        if (![context save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    } else {
        [context undo];
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

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[PTSettingsPetViewController class]]) {
        PTSettingsPetViewController *view = (PTSettingsPetViewController *)segue.destinationViewController;
        
        Pet *pet = [self.fetchedResultsController objectAtIndexPath:[self.tableView indexPathForSelectedRow]];
        if (!pet)
            pet = [Pet create:nil inManagedObjectContext:self.managedObjectContext];
        
        view.pet = pet;
    }
}

@end
