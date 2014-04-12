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
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name"
                                                              ascending:YES]];
    
    NSFetchedResultsController *frc = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:_managedObjectContext
                                                                          sectionNameKeyPath:@"name"
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
        NSCalendar *cal = [NSCalendar currentCalendar];
        NSDateComponents *components = [cal components:(NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit)
                                              fromDate:[NSDate date]];
        
        NSDate *today = [cal dateFromComponents:components];
        
        components = [[NSDateComponents alloc] init];
        [components setWeek:-1];
        NSDate *lastWeek = [cal dateByAddingComponents:components
                                                toDate:today
                                               options:0];
        
        components = [[NSDateComponents alloc] init];
        [components setMonth:-1];
        NSDate *lastMonth = [cal dateByAddingComponents:components
                                                 toDate:today
                                                options:0];
        
        
        int todayCount = 0;
        int weekCount = 0;
        int monthCount = 0;
        for (PetActivity *pa in [section objects]) {
            components = [cal components:(NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit)
                                fromDate:pa.date];
            NSDate *otherDate = [cal dateFromComponents:components];
            if([today isEqualToDate:otherDate]) {
                todayCount++;
            }
            if ([pa.date compare:lastWeek] == NSOrderedDescending) {
                weekCount++;
            }
            if ([pa.date compare:lastMonth] == NSOrderedDescending) {
                monthCount++;
            }
        }
        
        //        int totalCount = [section numberOfObjects];
        
        PTStatsObject *stat = [[PTStatsObject alloc] init];
        stat.sectionName = [section name];
        stat.dayCount = todayCount;
        stat.weekCount = weekCount;
        stat.monthCount = monthCount;
        [self.statsArray addObject:stat];
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

#pragma mark - UITableViewDataSource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return [[self.statsArray objectAtIndex:section] sectionName];
}

//override
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.statsArray count];
}

//override
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PTStatsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Stats Cell"];
    PTStatsObject *stat = [self.statsArray objectAtIndex:indexPath.section];
    
    // Configure the cell...
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    //[df setDateFormat:@"yyyy-MM-dd 'at' hh:mm a"];
    [df setDateStyle:NSDateFormatterShortStyle];
    [df setTimeStyle:NSDateFormatterShortStyle];
    
    cell.dayLabel.text = [NSString stringWithFormat:@"Totay: %d", stat.dayCount];
    cell.weekLabel.text = [NSString stringWithFormat:@"This Week: %d", stat.weekCount];
    cell.monthLabel.text = [NSString stringWithFormat:@"This Month: %d", stat.monthCount];
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
