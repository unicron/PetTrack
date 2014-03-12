//
//  PTFirstViewController.m
//  PetTracker
//
//  Created by Hannemann on 3/11/14.
//  Copyright (c) 2014 Hannemann. All rights reserved.
//

#import "PTFirstViewController.h"

@interface PTFirstViewController ()
@property (strong, nonatomic) NSMutableDictionary *history;
@property (weak, nonatomic) IBOutlet UIDatePicker *selectedDateTime;
@end

@implementation PTFirstViewController

- (NSMutableDictionary *)history {
    if (!_history) {
        _history = [[NSMutableDictionary alloc] init];
    }
    return _history;
}

- (IBAction)walkButton:(UIButton *)sender {
    [self.history setObject:self.selectedDateTime.date
                     forKey:@"Walk"];
}

- (IBAction)napButton:(UIButton *)sender {
    [self.history setObject:self.selectedDateTime.date
                     forKey:@"Nap"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}


@end
