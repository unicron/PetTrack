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
#import "HistoryCDTVC.h"
#import "PTStatsTableViewCell.h"

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
    
    //[VCHelper setBackground:self.view];
    self.navigationItem.title = @"Statistics";
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
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name"
                                                              ascending:YES]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:managedObjectContext
                                                                          sectionNameKeyPath:@"name"
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[HistoryCDTVC class]]) {
        HistoryCDTVC *view = (HistoryCDTVC *)segue.destinationViewController;
        view.managedObjectContext = self.managedObjectContext;
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        view.selectedIndexPath = indexPath;
    }
}

#pragma mark - Table view data source
//override
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

//override
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return [[[self.fetchedResultsController sections] objectAtIndex:section] numberOfObjects];
    //return 4;
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PTStatsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Stats Cell"];
    PetActivity *pa = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    // Configure the cell...
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    //[df setDateFormat:@"yyyy-MM-dd 'at' hh:mm a"];
    [df setDateStyle:NSDateFormatterShortStyle];
    [df setTimeStyle:NSDateFormatterShortStyle];
    
    //cell.textLabel.text = pa.name;
    //cell.detailTextLabel.text = [df stringFromDate:pa.date];
    cell.dayLabel.text = pa.name;
    
    return cell;
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Stats Cell"];
//    
//    id<NSFetchedResultsSectionInfo> section = [[self.fetchedResultsController sections] objectAtIndex:indexPath.section];
//    
//    NSCalendar *cal = [NSCalendar currentCalendar];
//    NSDateComponents *components = [cal components:(NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:[NSDate date]];
//    NSDate *today = [cal dateFromComponents:components];
//    
//    components = [[NSDateComponents alloc] init];
//    [components setWeek:-1];
//    NSDate *lastWeek = [cal dateByAddingComponents:components toDate:today options:0];
//    
//    components = [[NSDateComponents alloc] init];
//    [components setMonth:-1];
//    NSDate *lastMonth = [cal dateByAddingComponents:components toDate:today options:0];
//    
//    switch (indexPath.row) {
//        case 0:
//        {
//            int todayCount = 0;
//            for (PetActivity *pa in [section objects]) {
//                components = [cal components:(NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:pa.date];
//                NSDate *otherDate = [cal dateFromComponents:components];
//                if([today isEqualToDate:otherDate]) {
//                    todayCount++;
//                }
//            }
//            cell.textLabel.text = [NSString stringWithFormat:@"Today: %d", todayCount];
//        }
//            break;
//            
//        case 1: {
//            int weekCount = 0;
//            for (PetActivity *pa in [section objects]) {
//                if ([pa.date compare:lastWeek] == NSOrderedDescending) {
//                    weekCount++;
//                }
//            }
//            cell.textLabel.text = [NSString stringWithFormat:@"Week: %d", weekCount];
//        }
//            break;
//            
//        case 2: {
//            int monthCount = 0;
//            for (PetActivity *pa in [section objects]) {
//                if ([pa.date compare:lastMonth] == NSOrderedDescending) {
//                    monthCount++;
//                }
//            }
//            cell.textLabel.text = [NSString stringWithFormat:@"Month: %d", monthCount];
//        }
//            break;
//            
//        case 3: {
//            int totalCount = [section numberOfObjects];
//            cell.textLabel.text = [NSString stringWithFormat:@"Total: %d", totalCount];
//        }
//            break;
//            
//        default:
//            break;
//    }
//    
//    return cell;
//}


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
