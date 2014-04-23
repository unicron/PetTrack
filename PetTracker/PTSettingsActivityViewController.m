//
//  PTSettingsActivityViewController.m
//  PetTracker
//
//  Created by Hannemann on 4/23/14.
//  Copyright (c) 2014 Hannemann. All rights reserved.
//

#import "PTSettingsActivityViewController.h"
#import "NKOColorPickerView.h"

@interface PTSettingsActivityViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet NKOColorPickerView *colorPicker;
@property (weak, nonatomic) IBOutlet UIView *colorResult;
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
    
    [self setActivity:self.activity];
    
    NKOColorPickerDidChangeColorBlock colorPickerChangeBlock = ^(UIColor *color) {
        //Your code handling a color change in the picker view.
        color = [color colorWithAlphaComponent:0.5];
        self.colorResult.backgroundColor = color;
    };
    
    [self.colorPicker setDidChangeColorBlock:colorPickerChangeBlock];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setActivity:(Activity *)activity {
    _activity = activity;
    
    if (activity) {
        self.nameText.text = activity.name;
        
        UIColor *colorToSet = [[UIColor alloc] initWithRed:activity.bgred.floatValue / 255
                                                green:activity.bggreen.floatValue / 255
                                                 blue:activity.bgblue.floatValue / 255
                                                alpha:activity.bgalpha.floatValue];
        
        [self.colorPicker setColor:colorToSet];
        self.colorResult.backgroundColor = colorToSet;
    }
        
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
