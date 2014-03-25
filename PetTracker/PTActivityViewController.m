//
//  PTFirstViewController.m
//  PetTracker
//
//  Created by Hannemann on 3/11/14.
//  Copyright (c) 2014 Hannemann. All rights reserved.
//

#import "PTActivityViewController.h"
#import "PetActivity.h"
#import "PTHistoryCDTVC.h"
#import "PTViewControllerHelper.h"

@interface PTActivityViewController ()
@property (weak, nonatomic) IBOutlet UIDatePicker *selectedDateTime;
@property (weak, nonatomic) IBOutlet UISwitch *setTime;
@property (strong, nonatomic) UIManagedDocument *document;
@end

@implementation PTActivityViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    PTHistoryCDTVC *pth = (PTHistoryCDTVC *)segue.destinationViewController;
    pth.managedObjectContext = self.managedObjectContext;
}

- (IBAction)buttonPush:(UIButton *)sender {
    //PetActivity *pa = [[PetActivity alloc] init];
    NSManagedObjectContext *context = self.managedObjectContext;
    PetActivity *petActivity = [NSEntityDescription insertNewObjectForEntityForName:@"PetActivity"
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
    if (self.setTime.on) {
        self.selectedDateTime.hidden = NO;
    } else {
        self.selectedDateTime.hidden = YES;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [PTViewControllerHelper setBackground:self.view];
}


@end
