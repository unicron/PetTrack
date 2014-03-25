//
//  StatsCDTVC.m
//  PetTracker
//
//  Created by Hannemann on 3/25/14.
//  Copyright (c) 2014 Hannemann. All rights reserved.
//

#import "StatsCDTVC.h"
#import "VCHelper.h"
#import "PetActivity.h"

@interface StatsCDTVC ()

@end

@implementation StatsCDTVC

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
    
    [VCHelper setBackground:self.view];
    //self.navigationItem.title = @"Activity History";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    _managedObjectContext = managedObjectContext;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"PetActivity"];
    request.predicate = nil;
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date"
                                                              ascending:NO]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
    
}

#pragma mark - Table view data source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Stats Cell"];
    PetActivity *pa = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    // Configure the cell...
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    //[df setDateFormat:@"yyyy-MM-dd 'at' hh:mm a"];
    [df setDateStyle:NSDateFormatterShortStyle];
    [df setTimeStyle:NSDateFormatterShortStyle];
    
    cell.textLabel.text = pa.name;
    cell.detailTextLabel.text = [df stringFromDate:pa.date];
    
    return cell;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
