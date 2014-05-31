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
#import "PTStatsSection.h"
#import "PTKeyValuePair.h"

@interface StatsTableViewController ()
@property (strong, nonatomic) NSMutableArray *statsSectionArray;
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
    
    //make sure there are even activities at all...
    if ([[frc sections] count] < 1) {
        self.statsSectionArray = nil;
        return;
    }
    
    //find the earlist day for any activity and the number of days since
    NSFetchRequest *requestForMinDate = [NSFetchRequest fetchRequestWithEntityName:@"PetActivity"];
    NSArray *minDateArray = [_managedObjectContext executeFetchRequest:requestForMinDate error:nil];
    NSDate *earliestDate = [minDateArray valueForKeyPath:@"@min.date"];
    NSDateComponents *nowAndEnd = [[NSCalendar currentCalendar] components:NSDayCalendarUnit
                                                                  fromDate:earliestDate
                                                                    toDate:[[NSDate alloc] init]
                                                                   options:0];
    
    _statsSectionArray = [[NSMutableArray alloc] init];
    
    PTStatsSection *statsSectionAverageTime = [[PTStatsSection alloc] init];
    statsSectionAverageTime.sectionName = @"Average Time of Day";
    statsSectionAverageTime.statsObjects = [[NSMutableArray alloc] init];
    
    PTStatsSection *statsSectionNumberPerDay = [[PTStatsSection alloc] init];
    statsSectionNumberPerDay.sectionName = @"Number per Day";
    statsSectionNumberPerDay.statsObjects = [[NSMutableArray alloc] init];
    
    PTStatsSection *statsSectionMostFrequent = [[PTStatsSection alloc] init];
    statsSectionMostFrequent.sectionName = @"Most Frequent";
    statsSectionMostFrequent.statsObjects = [[NSMutableArray alloc] init];
    
    PTKeyValuePair *frequentActivity = [[PTKeyValuePair alloc] init];
    NSMutableDictionary *frequentDays = [[NSMutableDictionary alloc] init];
    for (id<NSFetchedResultsSectionInfo> querySection in [frc sections]) {
        
        NSDate *midnight;
        NSTimeInterval totalTi = 0;
        for (PetActivity *pa in [querySection objects]) {
            
            //get the hour/min/sec from each date and compare them to midnight
            NSCalendar *cal = [NSCalendar currentCalendar];
            NSDateComponents *components = [cal components:(NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit) fromDate:pa.date];
            NSDate *compareTime = [cal dateFromComponents:components];
            
            NSDateComponents *components2 = [cal components:(NSDayCalendarUnit) fromDate:pa.date];
            midnight = [cal dateFromComponents:components2];
            
            //add up the difference from midnight
            totalTi += [compareTime timeIntervalSinceDate:midnight];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"EEEE"];
            NSString *day = [dateFormatter stringFromDate:[NSDate date]];
            NSNumber *dayCount = [frequentDays objectForKey:day];
            if (!dayCount)
                dayCount = [[NSNumber alloc] initWithInt:0];
            [frequentDays setValue:([NSNumber numberWithInt:dayCount.intValue + 1]) forKey:day];
        }
        
        //take an average time of day
        NSTimeInterval averageTi = totalTi / [[querySection objects] count];
        
        //calculate the date object with the avg time of day
        NSDate *finalTime = [[NSDate alloc] initWithTimeInterval:averageTi sinceDate:midnight];
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        //[df setDateFormat:@"yyyy-MM-dd 'at' hh:mm a"];
        [df setTimeStyle:NSDateFormatterShortStyle];
        
        //set the stats object for display
        PTStatsObject *statAverageTime = [[PTStatsObject alloc] init];
        statAverageTime.titleText = querySection.name;
        statAverageTime.detailText = [NSString stringWithFormat:@"%@", [df stringFromDate:finalTime]];
        [statsSectionAverageTime.statsObjects addObject:statAverageTime];

        //calculate the number of times this activity occurs / number of days
        double num = [[querySection objects] count];
        NSInteger days = [nowAndEnd day];
        if (days > 0)
            num = num / days;
        
        //set the stats object for display
        PTStatsObject *statNumberPerDay = [[PTStatsObject alloc] init];
        statNumberPerDay.titleText = querySection.name;
        statNumberPerDay.detailText = [NSString stringWithFormat:@"%f", num];
        [statsSectionNumberPerDay.statsObjects addObject:statNumberPerDay];
        
        //keep track of the highest count for activity
        if ([[querySection objects] count] > frequentActivity.valueInt) {
            frequentActivity.keyString = querySection.name;
            frequentActivity.valueInt = [[querySection objects] count];
        }
        
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
        
//        [statsSection.statsObjects addObject:stat];
    }
    
    PTStatsObject *statMostFrequentActivity = [[PTStatsObject alloc] init];
    statMostFrequentActivity.titleText = @"Activity";
    statMostFrequentActivity.detailText = frequentActivity.keyString;
    //statMostFrequentActivity.detailText = [NSString stringWithFormat:@"%d", frequentActivity.valueInt];
    [statsSectionMostFrequent.statsObjects addObject:statMostFrequentActivity];
    
    PTStatsObject *statMostFrequentDay = [[PTStatsObject alloc] init];
    statMostFrequentDay.titleText = @"Day of week";
    
    NSEnumerator *enumerator = [frequentDays keyEnumerator];
    id key;
    PTKeyValuePair *frequentDayCount = [[PTKeyValuePair alloc] init];
    while ((key = [enumerator nextObject])) {
        NSNumber *dayCount = [frequentDays objectForKey:key];
        if (dayCount.intValue > frequentDayCount.valueInt) {
            frequentDayCount.keyString = key;
            frequentDayCount.valueInt = dayCount.intValue;
        }
    }
    
    statMostFrequentDay.detailText = frequentDayCount.keyString;
    [statsSectionMostFrequent.statsObjects addObject:statMostFrequentDay];
    
    [self.statsSectionArray addObject:statsSectionAverageTime];
    [self.statsSectionArray addObject:statsSectionNumberPerDay];
    [self.statsSectionArray addObject:statsSectionMostFrequent];
}

#pragma mark - UITableViewDataSource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    PTStatsSection *statsSection = [self.statsSectionArray objectAtIndex:section];
	return [statsSection sectionName];
//    return @"Daily Average Times";
//    return @"Total Counts";
//    return @"Average Time Summary";

}

//override
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.statsSectionArray count];
//    return 1;
}

//override
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return 1;
    PTStatsSection *statsSection = [self.statsSectionArray objectAtIndex:section];
    return [statsSection.statsObjects count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Stats Cell"];
    PTStatsSection *statsSection = [self.statsSectionArray objectAtIndex:indexPath.section];
    PTStatsObject *stat = [statsSection.statsObjects objectAtIndex:indexPath.row];
    
    // Configure the cell...
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    //[df setDateFormat:@"yyyy-MM-dd 'at' hh:mm a"];
    [df setTimeStyle:NSDateFormatterShortStyle];
    
    cell.textLabel.text = stat.titleText;
    cell.detailTextLabel.text = stat.detailText;
    
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
