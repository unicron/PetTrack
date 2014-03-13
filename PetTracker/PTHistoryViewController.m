//
//  PTSecondViewController.m
//  PetTracker
//
//  Created by Hannemann on 3/11/14.
//  Copyright (c) 2014 Hannemann. All rights reserved.
//

#import "PTHistoryViewController.h"
#import "PTPetActivity.h"

@interface PTHistoryViewController ()
@property (weak, nonatomic) IBOutlet UITextView *historyTextDisplay;
@end

@implementation PTHistoryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSMutableString *textDisplayString = [[NSMutableString alloc] init];
    if ([self.historyFromParent count] > 0) {
        for (PTPetActivity *pa in self.historyFromParent) {
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            [df setDateFormat:@"yyyy-MM-dd 'at' HH:mm"];
            
            
            [textDisplayString appendString:[NSString stringWithFormat:@"%@ %@ \r\n",
                                             pa.ActivityName,
                                             [df stringFromDate:pa.ActivityDateTime]]];
        }
    } else {
        [textDisplayString appendString:@"No history found!"];
    }
    
    self.historyTextDisplay.text = textDisplayString;
}


@end
