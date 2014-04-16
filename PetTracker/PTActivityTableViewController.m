//
//  PTActivityTableViewController.m
//  PetTracker
//
//  Created by Hannemann on 4/12/14.
//  Copyright (c) 2014 Hannemann. All rights reserved.
//

#import "PTActivityTableViewController.h"
#import "StatsTableViewController.h"
#import "PetActivity.h"
#import "PetActivity+Database.h"
#import "PTRecordActivityViewController.h"

//@interface ActivityViewController ()
//@property (weak, nonatomic) IBOutlet UIDatePicker *selectedDateTime;
//@property (weak, nonatomic) IBOutlet UISwitch *setTime;
//@end
//
//@implementation ActivityViewController
//
//- (IBAction)buttonPush:(UIButton *)sender {
//
//- (IBAction)setTimeToggle:(UISwitch *)sender {
//    self.selectedDateTime.date = [[NSDate alloc] init];
//    self.selectedDateTime.hidden = !self.selectedDateTime.hidden;
//}


@interface PTActivityTableViewController ()
@property (strong, nonatomic) NSString *activityText;
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
    //NSLog(@"Sections: %d", [tableView numberOfSections]);
    //return [tableView numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 8;
    //NSLog(@"Rows: %d", [tableView numberOfRowsInSection:section]);
    //return [tableView numberOfRowsInSection:section];
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.activityText = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[PTRecordActivityViewController class]]) {
        PTRecordActivityViewController *view = (PTRecordActivityViewController *)segue.destinationViewController;
        view.managedObjectContext = self.managedObjectContext;
        view.activityText = self.activityText;
    }
}

@end
