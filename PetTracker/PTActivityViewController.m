//
//  PTFirstViewController.m
//  PetTracker
//
//  Created by Hannemann on 3/11/14.
//  Copyright (c) 2014 Hannemann. All rights reserved.
//

#import "PTActivityViewController.h"
#import "PTPetActivity.h"
#import "PTHistoryViewController.h"

@interface PTActivityViewController ()
@property (strong, nonatomic) NSMutableArray *history;
@property (weak, nonatomic) IBOutlet UIDatePicker *selectedDateTime;
@property (weak, nonatomic) IBOutlet UISwitch *setTime;
@end

@implementation PTActivityViewController

- (NSMutableArray *)history {
    if (!_history) {
        _history = [[NSMutableArray alloc] init];
    }
    return _history;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    PTHistoryViewController *pth = (PTHistoryViewController *)segue.destinationViewController;
    pth.historyFromParent = self.history;
}

- (IBAction)buttonPush:(UIButton *)sender {
    PTPetActivity *pa = [[PTPetActivity alloc] init];
    pa.ActivityName = sender.titleLabel.text;
    if (self.setTime.on) {
        pa.ActivityDateTime = self.selectedDateTime.date;
    } else {
        pa.ActivityDateTime = [[NSDate alloc] init];
    }
    
    [self.history addObject:pa];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"backgroundImage"]];
    backgroundView.alpha = 0.5;
    backgroundView.frame = self.view.bounds;
    [self.view addSubview:backgroundView];
    [self.view sendSubviewToBack:backgroundView];
}


@end
