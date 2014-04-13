//
//  PTPetViewController.m
//  PetTracker
//
//  Created by Hannemann on 4/4/14.
//  Copyright (c) 2014 Hannemann. All rights reserved.
//

#import "PTPetViewController.h"
#import "PTActivityTableViewController.h"
#import "ViewControllerHelper.h"

@interface PTPetViewController ()

@end

@implementation PTPetViewController

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
    
    //use this as temporary image until user sets one
    //[ViewControllerHelper setBackground:self.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[PTActivityTableViewController class]]) {
        PTActivityTableViewController *view = (PTActivityTableViewController *)segue.destinationViewController;
        view.managedObjectContext = self.managedObjectContext;
    }
}

@end
