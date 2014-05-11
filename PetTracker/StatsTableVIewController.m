//
//  StatsCDTVC.m
//  PetTracker
//
//  Created by Hannemann on 3/25/14.
//  Copyright (c) 2014 Hannemann. All rights reserved.
//

#import "StatsTableViewController.h"
#import "ViewControllerHelper.h"
#import "PetActivity.h"
#import "HistoryCDTVC.h"
#import "PTStatsTableViewCell.h"
#import "PTStatsObject.h"


@interface StatsTableViewController ()
@property (strong, nonatomic) NSMutableArray *statsArray;
@end


@implementation StatsTableViewController

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

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupArray];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupArray {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"PetActivity"];
    request.predicate = nil;
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"activity.name"
                                                              ascending:YES]];
    
    NSFetchedResultsController *frc = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:_managedObjectContext
                                                                          sectionNameKeyPath:@"activity.name"
                                                                                   cacheName:nil];
    NSError *error = nil;
	if (![frc performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    _statsArray = [[NSMutableArray alloc] init];
    for (id<NSFetchedResultsSectionInfo> section in [frc sections]) {
        
        NSTimeInterval totalTi = 0;
        int count = 0;
        NSDate *date2;
        for (PetActivity *pa in [section objects]) {
            
            //get the hour/min/sec from each date and compare them to midnight
            NSCalendar *cal = [NSCalendar currentCalendar];
            NSDateComponents *components = [cal components:(NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit)
                                                  fromDate:pa.date];
            NSDate *date = [cal dateFromComponents:components];
            
            NSDateComponents *components2 = [cal components:(NSDayCalendarUnit)
                                                   fromDate:pa.date];
            date2 = [cal dateFromComponents:components2];
            
            totalTi = totalTi + [date timeIntervalSinceDate:date2];
            count++;
        }
        
        NSTimeInterval averageTi = totalTi / count;
        
        NSDate *finalDate = [[NSDate alloc] initWithTimeInterval:averageTi sinceDate:date2];
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        //[df setDateFormat:@"yyyy-MM-dd 'at' hh:mm a"];
        [df setTimeStyle:NSDateFormatterShortStyle];
        
        
        PTStatsObject *stat = [[PTStatsObject alloc] init];
        stat.titleText = [NSString stringWithFormat:@"%d - %@", [[section objects] count], [section name]];
        stat.detailText = [NSString stringWithFormat:@"%@", [df stringFromDate:finalDate]];
        
        
//        NSCalendar *cal = [NSCalendar currentCalendar];
//        NSDateComponents *components = [cal components:(NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit)
//                                              fromDate:[NSDate date]];
//        
//        NSDate *today = [cal dateFromComponents:components];
//        
//        components = [[NSDateComponents alloc] init];
//        [components setWeek:-1];
//        NSDate *lastWeek = [cal dateByAddingComponents:components
//                                                toDate:today
//                                               options:0];
//        
//        components = [[NSDateComponents alloc] init];
//        [components setMonth:-1];
//        NSDate *lastMonth = [cal dateByAddingComponents:components
//                                                 toDate:today
//                                                options:0];
        
        
//        int todayCount = 0;
//        int weekCount = 0;
//        int monthCount = 0;
//        for (PetActivity *pa in [section objects]) {
//            components = [cal components:(NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit)
//                                fromDate:pa.date];
//            NSDate *otherDate = [cal dateFromComponents:components];
//            if([today isEqualToDate:otherDate]) {
//                todayCount++;
//            }
//            if ([pa.date compare:lastWeek] == NSOrderedDescending) {
//                weekCount++;
//            }
//            if ([pa.date compare:lastMonth] == NSOrderedDescending) {
//                monthCount++;
//            }
//        }
        
//        stat.sectionName = [section name];
//        stat.dayCount = todayCount;
//        stat.weekCount = weekCount;
//        stat.monthCount = monthCount;
        
        [self.statsArray addObject:stat];
    }
}

#pragma mark - UITableViewDataSource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
//	return [[self.statsArray objectAtIndex:section] sectionName];
//    return @"Daily Average Times";
//    return @"Total Counts";
    return @"Average Time Summary";

}

//override
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    return [self.statsArray count];
    return 1;
}

//override
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return 1;
    return [self.statsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Stats Cell"];
    PTStatsObject *stat = [self.statsArray objectAtIndex:indexPath.row];
    
    // Configure the cell...
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    //[df setDateFormat:@"yyyy-MM-dd 'at' hh:mm a"];
    [df setTimeStyle:NSDateFormatterShortStyle];
    
    cell.textLabel.text = stat.titleText;
    cell.detailTextLabel.text = stat.detailText;
    
    //    PTStatsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Stats Cell"];
    //    PTStatsObject *stat = [self.statsArray objectAtIndex:indexPath.section];
    
    //    cell.dayLabel.text = [NSString stringWithFormat:@"Totay: %d", stat.dayCount];
    //    cell.weekLabel.text = [NSString stringWithFormat:@"This Week: %d", stat.weekCount];
    //    cell.monthLabel.text = [NSString stringWithFormat:@"This Month: %d", stat.monthCount];
    
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[HistoryCDTVC class]]) {
        HistoryCDTVC *view = (HistoryCDTVC *)segue.destinationViewController;
        view.managedObjectContext = self.managedObjectContext;
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        view.selectedIndexPath = indexPath;
    }
}

@end
