//
//  PTFirstViewController.m
//  PetTracker
//
//  Created by Hannemann on 3/11/14.
//  Copyright (c) 2014 Hannemann. All rights reserved.
//

#import "ActivityViewController.h"
#import "PetActivity.h"
#import "PetActivity+Database.h"
#import "ViewControllerHelper.h"
#import "StatsTableViewController.h"

@interface ActivityViewController ()
@property (weak, nonatomic) IBOutlet UIDatePicker *selectedDateTime;
@property (weak, nonatomic) IBOutlet UISwitch *setTime;
@end

@implementation ActivityViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[StatsTableViewController class]]) {
        StatsTableViewController *view = (StatsTableViewController *)segue.destinationViewController;
        view.managedObjectContext = self.managedObjectContext;
    }
}

- (IBAction)buttonPush:(UIButton *)sender {
    NSManagedObjectContext *context = self.managedObjectContext;
    PetActivity *petActivity = [PetActivity create:nil
                            inManagedObjectContext:context];
    
    petActivity.name = sender.titleLabel.text;
    
    if (self.setTime.on) {
        petActivity.date = self.selectedDateTime.date;
    } else {
        petActivity.date = [[NSDate alloc] init];
    }
    
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

- (IBAction)setTimeToggle:(UISwitch *)sender {
    self.selectedDateTime.date = [[NSDate alloc] init];
    self.selectedDateTime.hidden = !self.selectedDateTime.hidden;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [ViewControllerHelper setBackground:self.view];
}


@end
