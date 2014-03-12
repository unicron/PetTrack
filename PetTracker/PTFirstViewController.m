//
//  PTFirstViewController.m
//  PetTracker
//
//  Created by Hannemann on 3/11/14.
//  Copyright (c) 2014 Hannemann. All rights reserved.
//

#import "PTFirstViewController.h"
#import "PTPetActivity.h"
#import "PTSecondViewController.h"

@interface PTFirstViewController ()
@property (strong, nonatomic) NSMutableArray *history;
@property (strong, nonatomic) IBOutlet UIDatePicker *selectedDateTime;
@end

@implementation PTFirstViewController

- (NSMutableArray *)history {
    if (!_history) {
        _history = [[NSMutableArray alloc] init];
    }
    return _history;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    PTSecondViewController *pt2 = (PTSecondViewController *)segue.destinationViewController;
    pt2.historyFromParent = self.history;
}

- (IBAction)walkButton:(UIButton *)sender {
    PTPetActivity *pa = [[PTPetActivity alloc] init];
    pa.ActivityName = @"Walk";
    pa.ActivityDateTime = self.selectedDateTime.date;
    
    [self.history addObject:pa];
}

- (IBAction)napButton:(UIButton *)sender {
    PTPetActivity *pa = [[PTPetActivity alloc] init];
    pa.ActivityName = @"Nap";
    pa.ActivityDateTime = self.selectedDateTime.date;
    
    [self.history addObject:pa];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}


@end
