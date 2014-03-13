//
//  PTBaseViewController.m
//  PetTracker
//
//  Created by Hannemann on 3/12/14.
//  Copyright (c) 2014 Hannemann. All rights reserved.
//

#import "PTBaseViewController.h"

@interface PTBaseViewController ()

@end

@implementation PTBaseViewController

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
    [self setBackground];
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

- (void)setBackground
{
	// Do any additional setup after loading the view, typically from a nib.
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"backgroundImage"]];
    backgroundView.alpha = 0.3;
    backgroundView.frame = self.view.bounds;
    [self.view addSubview:backgroundView];
    [self.view sendSubviewToBack:backgroundView];
}

@end
