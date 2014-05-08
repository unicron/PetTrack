//
//  PTSettingsTableViewController.m
//  PetTracker
//
//  Created by Hannemann on 4/16/14.
//  Copyright (c) 2014 Hannemann. All rights reserved.
//

#import "PTSettingsTableViewController.h"
#import "PTSettingsManagePetsCDTVC.h"
#import "PTSettingsManageActivitesCDTVC.h"
#import "ViewControllerHelper.h"

@interface PTSettingsTableViewController () <UIAlertViewDelegate>

@end

@implementation PTSettingsTableViewController

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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [ViewControllerHelper resetContext:self.managedObjectContext];
        [self showResetCompleteAlert];
    }
}

- (void)showResetCompleteAlert {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                    message:@"Reset All Complete!"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    
    [alert show];
}

- (void)showResetAlert {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                    message:@"This will delete all of your custom Pets and Activities, along with all data you have recorded using the app.  Are you sure you wish to proceed?"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"OK", nil];
    
    [alert show];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 4;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 3:
            [self showResetAlert];
            break;
            
        default:
            break;
    }
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[PTSettingsManagePetsCDTVC class]]) {
        PTSettingsManagePetsCDTVC *view = (PTSettingsManagePetsCDTVC *)segue.destinationViewController;
        view.managedObjectContext = self.managedObjectContext;
        
    } else if ([segue.destinationViewController isKindOfClass:[PTSettingsManageActivitesCDTVC class]]) {
        PTSettingsManageActivitesCDTVC *view = (PTSettingsManageActivitesCDTVC *)segue.destinationViewController;
        view.managedObjectContext = self.managedObjectContext;
        
    }
}

@end
