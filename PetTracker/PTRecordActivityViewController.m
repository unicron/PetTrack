//
//  PTRecordActivityViewController.m
//  PetTracker
//
//  Created by Hannemann on 4/13/14.
//  Copyright (c) 2014 Hannemann. All rights reserved.
//

#import "PTRecordActivityViewController.h"
#import "PetActivity.h"
#import "PetActivity+Database.h"

@interface PTRecordActivityViewController ()

@end

@implementation PTRecordActivityViewController

- (IBAction)saveActivity:(id)sender {
    NSManagedObjectContext *context = self.managedObjectContext;
    PetActivity *petActivity = [PetActivity create:nil
                            inManagedObjectContext:context];
    
    petActivity.name = self.activityText;
    //petActivity.name = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    
    //if (self.setTime.on) {
    //    petActivity.date = self.selectedDateTime.date;
    //} else {
    petActivity.date = [[NSDate alloc] init];
    //}
    
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
