//
//  PTSettingsActivityViewController.m
//  PetTracker
//
//  Created by Hannemann on 4/23/14.
//  Copyright (c) 2014 Hannemann. All rights reserved.
//

#import "PTSettingsActivityViewController.h"
#import "NKOColorPickerView.h"
#import "Activity+Database.h"

@interface PTSettingsActivityViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet NKOColorPickerView *colorPicker;
@property (weak, nonatomic) IBOutlet UIView *colorResult;
@property (weak, nonatomic) IBOutlet UINavigationItem *navTitle;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (strong, nonatomic, readwrite) Activity *returnActivity;
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
        
    } else {
        self.navTitle.title = @"Add Activity";
        self.deleteButton.hidden = YES;
    }
        
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Navigation

- (void)setPropertiesOnActivity:(Activity *)activity
{
    activity.name = self.nameText.text;
    
    const CGFloat *colorComponents = CGColorGetComponents(self.colorResult.backgroundColor.CGColor);
    
    activity.bgred = [NSNumber numberWithFloat:colorComponents[0] * 255];
    activity.bggreen = [NSNumber numberWithFloat:colorComponents[1] * 255];
    activity.bgblue = [NSNumber numberWithFloat:colorComponents[2] * 255];
    activity.bgalpha = [NSNumber numberWithFloat:colorComponents[3]];
    
    self.returnActivity = activity;
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Unwind Done"]) {
        if (self.activity) {
            [self setPropertiesOnActivity:self.activity];
            
        } else {
            NSManagedObjectContext *context = self.managedObjectContext;
            Activity *newActivity = [Activity create:nil inManagedObjectContext:context];
            [self setPropertiesOnActivity:newActivity];
        }
        
    } else if ([segue.identifier isEqualToString:@"Unwind Delete"] && self.activity) {
        NSManagedObjectContext *context = self.managedObjectContext;
        [context deleteObject:self.activity];
        self.activity = nil;
        self.returnActivity = nil;
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"Unwind Done"]) {
        
        if ([self.nameText.text length]) {
            return YES;
            
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Please enter a name for this Activity"
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"OK", nil];
            [alert show];
            return NO;
        }
    }
    
    return [super shouldPerformSegueWithIdentifier:identifier sender:sender];
}

@end
