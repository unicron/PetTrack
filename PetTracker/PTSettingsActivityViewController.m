//
//  PTSettingsActivityViewController.m
//  PetTracker
//
//  Created by Hannemann on 4/23/14.
//  Copyright (c) 2014 Hannemann. All rights reserved.
//

#import "PTSettingsActivityViewController.h"

@interface PTSettingsActivityViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameText;

@end

@implementation PTSettingsActivityViewController

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

- (IBAction)cancelClicked:(id)sender {
    self.activity = nil;
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)deleteActivity:(id)sender {
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    self.activity.name = self.nameText.text;
//    self.pet.picture = [NSData dataWithData:UIImagePNGRepresentation(self.imageView.image)];
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([self.nameText.text length])
        return YES;
    
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Please enter a name for this Activity"
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
        [alert show];
        return NO;
    }
}

@end
