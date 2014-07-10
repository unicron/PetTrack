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
#import "Activity.h"
#import "HistoryCDTVC.h"
#import "PTStatsTableViewCell.h"
#import "PTStatsObject.h"
#import "PTStatsSection.h"
#import "PTKeyValuePair.h"

@interface StatsTableViewController ()
@property (strong, nonatomic) NSMutableArray *statsSectionArray;
@property (strong, nonatomic) NSMutableArray *orderedTimeOfDayArray;
@property (strong, nonatomic) NSMutableArray *orderedTimeOfDayComparers;
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
    
    self.navigationItem.title = @"Statistics";
    
    self.orderedTimeOfDayArray = [[NSMutableArray alloc] init];
    [self.orderedTimeOfDayArray addObject:@"Early Morning"];
    [self.orderedTimeOfDayArray addObject:@"Mid Morning"];
    [self.orderedTimeOfDayArray addObject:@"Noon"];
    [self.orderedTimeOfDayArray addObject:@"Afternoon"];
    [self.orderedTimeOfDayArray addObject:@"After Work"];
    [self.orderedTimeOfDayArray addObject:@"Evening"];
    [self.orderedTimeOfDayArray addObject:@"Late Night"];
    [self.orderedTimeOfDayArray addObject:@"Really Late"];
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

- (NSString *)getHumanReadableFrequency:(double)num {
    NSString *numHumanReadable = @"Almost Never";
    
    if (num > 0.1)
        numHumanReadable = @"Occasionally";
    if (num > 0.25)
        numHumanReadable = @"Sometimes";
    if (num > 0.5)
        numHumanReadable = @"Every Other Day";
    if (num > 0.75)
        numHumanReadable = @"Often";
    if (num > 1.0)
        numHumanReadable = @"Daily";
    if (num > 1.5)
        numHumanReadable = @"Frequently";
    if (num > 2.0)
        numHumanReadable = @"Multiple Per Day";
    if (num > 3.0)
        numHumanReadable = @"All The Time";
    
    return numHumanReadable;
}

- (void)setupArray {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"PetActivity"];
    request.predicate = [NSPredicate predicateWithFormat:@"pet == %@", self.pet];
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
    requestForMinDate.predicate = [NSPredicate predicateWithFormat:@"pet == %@", self.pet];
    NSArray *minDateArray = [_managedObjectContext executeFetchRequest:requestForMinDate error:nil];
    NSDate *earliestDate = [minDateArray valueForKeyPath:@"@min.date"];
    NSDate *nowDate = [[NSDate alloc] init];
    NSDateComponents *nowAndEnd = [[NSCalendar currentCalendar] components:NSDayCalendarUnit
                                                                  fromDate:earliestDate
                                                                    toDate:nowDate
                                                                   options:0];
    
    _statsSectionArray = [[NSMutableArray alloc] init];
    
    //this will hold the "normal" day activity breakdown that is human-readable
    NSMutableDictionary *normalDay = [[NSMutableDictionary alloc] init];
    
    PTStatsSection *statsSectionAverageTime = [[PTStatsSection alloc] init];
    statsSectionAverageTime.sectionName = @"Average Time of Day";
    statsSectionAverageTime.statsObjects = [[NSMutableArray alloc] init];
    
    PTStatsSection *statsSectionNumberPerDay = [[PTStatsSection alloc] init];
    statsSectionNumberPerDay.sectionName = @"Frequency";
    statsSectionNumberPerDay.statsObjects = [[NSMutableArray alloc] init];
    
    PTStatsSection *statsSectionMostFrequent = [[PTStatsSection alloc] init];
    statsSectionMostFrequent.sectionName = @"Most Frequent";
    statsSectionMostFrequent.statsObjects = [[NSMutableArray alloc] init];
    
    PTKeyValuePair *frequentActivity = [[PTKeyValuePair alloc] init];
    NSMutableDictionary *frequentDays = [[NSMutableDictionary alloc] init];
    
    for (id<NSFetchedResultsSectionInfo> querySection in [frc sections]) {
        //calculate the number of times this activity occurs / number of days
        double num = [[querySection objects] count];
        NSInteger days = [nowAndEnd day];
        if (days > 0)
            num = num / days;
        
        NSString *numHumanReadable = [self getHumanReadableFrequency:num];
        
        //set the stats object for display of num per day
        PTStatsObject *statNumberPerDay = [[PTStatsObject alloc] init];
        statNumberPerDay.titleText = querySection.name;
        statNumberPerDay.detailText = [NSString stringWithFormat:@"%@ (%.02f)",numHumanReadable, num];
        [statsSectionNumberPerDay.statsObjects addObject:statNumberPerDay];
        
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
            NSTimeInterval diffSinceMidnight = [compareTime timeIntervalSinceDate:midnight];
            totalTi += diffSinceMidnight;
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"EEEE"];
            NSString *day = [dateFormatter stringFromDate:[NSDate date]];
            NSNumber *dayCount = [frequentDays objectForKey:day];
            if (!dayCount)
                dayCount = [[NSNumber alloc] initWithInt:0];
            
            [frequentDays setValue:([NSNumber numberWithInt:dayCount.intValue + 1]) forKey:day];
            
            [self addActivity:pa toNormalDay:normalDay];
        }
        
        //take an average time of day
        NSTimeInterval averageTi = totalTi / [[querySection objects] count];
        
        //calculate the date object with the avg time of day
        NSDate *finalTime = [[NSDate alloc] initWithTimeInterval:averageTi sinceDate:midnight];
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        //[df setDateFormat:@"yyyy-MM-dd 'at' hh:mm a"];
        [df setTimeStyle:NSDateFormatterShortStyle];
        
        //set the stats object for display of average time
        PTStatsObject *statAverageTime = [[PTStatsObject alloc] init];
        statAverageTime.titleText = querySection.name;
        statAverageTime.detailText = [NSString stringWithFormat:@"%@", [df stringFromDate:finalTime]];
        [statsSectionAverageTime.statsObjects addObject:statAverageTime];

        //keep track of the highest count for activity
        if ([[querySection objects] count] > frequentActivity.valueInt) {
            frequentActivity.keyString = querySection.name;
            frequentActivity.valueInt = [[querySection objects] count];
        }
    }
    
//    //iterate days
//    NSDate *nextDate;
//    for (nextDate = earliestDate; [nextDate compare:nowDate] < 0; nextDate = [nextDate dateByAddingTimeInterval:24*60*60]) {
//        [frc fetchedObjects];
//    }
    
    PTStatsObject *statMostFrequentActivity = [[PTStatsObject alloc] init];
    statMostFrequentActivity.titleText = @"Activity";
    statMostFrequentActivity.detailText = frequentActivity.keyString;
    //statMostFrequentActivity.detailText = [NSString stringWithFormat:@"%d", frequentActivity.valueInt];
    [statsSectionMostFrequent.statsObjects addObject:statMostFrequentActivity];
    
    PTStatsObject *statMostFrequentDay = [[PTStatsObject alloc] init];
    statMostFrequentDay.titleText = @"Day of week";
    
    NSEnumerator *keyEnumerator = [frequentDays keyEnumerator];
    id key;
    PTKeyValuePair *frequentDayCount = [[PTKeyValuePair alloc] init];
    while ((key = [keyEnumerator nextObject])) {
        NSNumber *dayCount = [frequentDays objectForKey:key];
        if (dayCount.intValue > frequentDayCount.valueInt) {
            frequentDayCount.keyString = key;
            frequentDayCount.valueInt = dayCount.intValue;
        }
    }
    
    statMostFrequentDay.detailText = frequentDayCount.keyString;
    [statsSectionMostFrequent.statsObjects addObject:statMostFrequentDay];
    
    for (NSString *timeOfDay in self.orderedTimeOfDayArray) {
        PTStatsSection *statsSectionNormalDay = [[PTStatsSection alloc] init];
        statsSectionNormalDay.sectionName = timeOfDay;
        statsSectionNormalDay.statsObjects = [[NSMutableArray alloc] init];
        NSDictionary *activityCount = [normalDay objectForKey:timeOfDay];
        
        NSEnumerator *keyEnumerator2 = [activityCount keyEnumerator];
        id key2;
        while ((key2 = [keyEnumerator2 nextObject])) {
            PTStatsObject *statNormalDayActivity = [[PTStatsObject alloc] init];
            statNormalDayActivity.titleText = key2;
            statNormalDayActivity.detailText = [activityCount objectForKey:key2];
            [statsSectionNormalDay.statsObjects addObject:statNormalDayActivity];
        }
        
        if ([statsSectionNormalDay.statsObjects count] > 0)
            [self.statsSectionArray addObject:statsSectionNormalDay];
    }
    
//    [self.statsSectionArray addObject:statsSectionNormalDay];
    [self.statsSectionArray addObject:statsSectionAverageTime];
    [self.statsSectionArray addObject:statsSectionNumberPerDay];
    [self.statsSectionArray addObject:statsSectionMostFrequent];
}

- (void)addActivity:(PetActivity *)pa toNormalDay:(NSMutableDictionary *)normalDay {
    NSString *timeOfDay = @"Midnight";
    NSString *activityName = pa.activity.name;
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:(NSDayCalendarUnit) fromDate:pa.date];
    
    NSDate *midnight = [cal dateFromComponents:components];             //12am
    NSDate *earlyMorning = [midnight dateByAddingTimeInterval:5*60*60]; //6am
    NSDate *midMorning = [midnight dateByAddingTimeInterval:9*60*60];   //9am
    NSDate *noon = [midnight dateByAddingTimeInterval:12*60*60];        //12pm
    NSDate *afternoon = [midnight dateByAddingTimeInterval:15*60*60];   //3pm
    NSDate *afterWork = [midnight dateByAddingTimeInterval:18*60*60];   //6pm
    NSDate *evening = [midnight dateByAddingTimeInterval:21*60*60];     //9pm
    NSDate *lateNight = [midnight dateByAddingTimeInterval:24*60*60];   //12am next day

    components = [cal components:(NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit) fromDate:pa.date];
    NSDate *compareTime = [cal dateFromComponents:components];
    
    if ([compareTime compare:midnight] == NSOrderedDescending && [compareTime compare:earlyMorning] == NSOrderedAscending)
        timeOfDay = self.orderedTimeOfDayArray[0];
    else if ([compareTime compare:earlyMorning] == NSOrderedDescending && [compareTime compare:midMorning] == NSOrderedAscending)
        timeOfDay = self.orderedTimeOfDayArray[1];
    else if ([compareTime compare:midMorning] == NSOrderedDescending && [compareTime compare:noon] == NSOrderedAscending)
        timeOfDay = self.orderedTimeOfDayArray[2];
    else if ([compareTime compare:noon] == NSOrderedDescending && [compareTime compare:afternoon] == NSOrderedAscending)
        timeOfDay = self.orderedTimeOfDayArray[3];
    else if ([compareTime compare:afternoon] == NSOrderedDescending && [compareTime compare:afterWork] == NSOrderedAscending)
        timeOfDay = self.orderedTimeOfDayArray[4];
    else if ([compareTime compare:afterWork] == NSOrderedDescending && [compareTime compare:evening] == NSOrderedAscending)
        timeOfDay = self.orderedTimeOfDayArray[5];
    else if ([compareTime compare:evening] == NSOrderedDescending && [compareTime compare:lateNight] == NSOrderedAscending)
        timeOfDay = self.orderedTimeOfDayArray[6];
    else
        timeOfDay = self.orderedTimeOfDayArray[7];
    
    NSMutableDictionary *dictForTimeOfDay = [normalDay objectForKey:timeOfDay];
    if (!dictForTimeOfDay)
        dictForTimeOfDay = [[NSMutableDictionary alloc] init];
    
    NSNumber *count = [dictForTimeOfDay objectForKey:activityName];
    if (!count)
        count = [[NSNumber alloc] initWithInt:0];
    
    count = [NSNumber numberWithInt:count.intValue + 1];
    [dictForTimeOfDay setValue:count forKey:activityName];
    
    [normalDay setValue:dictForTimeOfDay forKey:timeOfDay];
}

#pragma mark - UITableViewDataSource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    PTStatsSection *statsSection = [self.statsSectionArray objectAtIndex:section];
	return [statsSection sectionName];
}

//override
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.statsSectionArray count];
}

//override
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    PTStatsSection *statsSection = [self.statsSectionArray objectAtIndex:section];
    return [statsSection.statsObjects count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Stats Cell"];
    PTStatsSection *statsSection = [self.statsSectionArray objectAtIndex:indexPath.section];
    PTStatsObject *stat = [statsSection.statsObjects objectAtIndex:indexPath.row];
    
    // Configure the cell...
    
//    NSDateFormatter *df = [[NSDateFormatter alloc] init];
//    //[df setDateFormat:@"yyyy-MM-dd 'at' hh:mm a"];
//    [df setTimeStyle:NSDateFormatterShortStyle];
    
    cell.textLabel.text = stat.titleText;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", stat.detailText];
    
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[HistoryCDTVC class]]) {
        HistoryCDTVC *view = (HistoryCDTVC *)segue.destinationViewController;
        view.pet = self.pet;
        view.managedObjectContext = self.managedObjectContext;

        
        //NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        //view.selectedIndexPath = indexPath;
    }
}

@end
