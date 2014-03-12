//
//  PTSecondViewController.m
//  PetTracker
//
//  Created by Hannemann on 3/11/14.
//  Copyright (c) 2014 Hannemann. All rights reserved.
//

#import "PTSecondViewController.h"
#import "PTPetActivity.h"

@interface PTSecondViewController ()
@property (weak, nonatomic) IBOutlet UITextView *historyTextDisplay;

@end

@implementation PTSecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSMutableString *textDisplayString = [[NSMutableString alloc] init];
    for (PTPetActivity *pa in self.historyFromParent) {
        [textDisplayString appendString:[NSString stringWithFormat:@"%@ %@ \r\n", pa.ActivityName, pa.ActivityDateTime]];
    }
    
    self.historyTextDisplay.text = textDisplayString;
}


@end
