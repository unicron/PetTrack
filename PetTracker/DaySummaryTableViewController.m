//
//  StatsCDTVC.m
//  PetTracker
//
//  Created by Hannemann on 3/25/14.
//  Copyright (c) 2014 Hannemann. All rights reserved.
//

#import "DaySummaryTableViewController.h"
#import "StatsTableViewController.h"
#import "ViewControllerHelper.h"
#import "PetActivity.h"
#import "Activity.h"
#import "HistoryCDTVC.h"
#import "PTStatsTableViewCell.h"
#import "PTStatsObject.h"
#import "PTStatsSection.h"
#import "PTKeyValuePair.h"

@interface DaySummaryTableViewController ()
@property (strong, nonatomic) NSMutableArray *statsSectionArray;
@property (strong, nonatomic) NSMutableArray *orderedTimeOfDayArray;
@property (strong, nonatomic) NSMutableArray *orderedTimeOfDayComparers;
@end


@implementation DaySummaryTableViewController

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
    
    self.navigationItem.title = @"Day Summary";
    
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
    //now get the total number of days we are looking at
    NSInteger days = [nowAndEnd day];
    
    //init the overall table array
    _statsSectionArray = [[NSMutableArray alloc] init];
    
    //this will hold the "normal" day activity breakdown that is human-readable
    NSMutableDictionary *normalDay = [[NSMutableDictionary alloc] init];
    
    for (id<NSFetchedResultsSectionInfo> querySection in [frc sections]) {
        for (PetActivity *pa in [querySection objects]) {
            [self addActivity:pa toNormalDay:normalDay];
        }
    }
    

    
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
            
            NSNumber *num = [activityCount objectForKey:key2];
            //calculate the number of times this activity occurs / number of days
            if (days > 0)
                num = [NSNumber numberWithDouble:[num doubleValue] / days];
            NSString *numHumanReadable = [self getHumanReadableFrequency:[num doubleValue]];
            
            statNormalDayActivity.detailText = numHumanReadable;
            [statsSectionNormalDay.statsObjects addObject:statNormalDayActivity];
        }
        
        if ([statsSectionNormalDay.statsObjects count] > 0)
            [self.statsSectionArray addObject:statsSectionNormalDay];
    }
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
        
    } else if ([segue.destinationViewController isKindOfClass:[StatsTableViewController class]]) {
        StatsTableViewController *view = (StatsTableViewController *)segue.destinationViewController;
        view.pet = self.pet;
        view.managedObjectContext = self.managedObjectContext;
        
    }
}

@end
