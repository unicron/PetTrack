//
//  PTRecordActivityViewController.m
//  PetTracker
//
//  Created by Hannemann on 4/13/14.
//  Copyright (c) 2014 Hannemann. All rights reserved.
//

#import "PTRecordActivityViewController.h"
#import "PetActivity.h"
#import "PetActivity+Database.h"


@interface PTRecordActivityViewController ()
@property (weak, nonatomic) IBOutlet UILabel *activityLabel;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UILabel *petLabel;
@end


@implementation PTRecordActivityViewController

- (IBAction)saveActivity:(id)sender {
    NSManagedObjectContext *context = self.managedObjectContext;
    PetActivity *petActivity = [PetActivity create:nil inManagedObjectContext:context];
    
    petActivity.pet = self.pet;
    petActivity.activity = self.activity;
    petActivity.date = self.datePicker.date;
    
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

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
    
    self.datePicker.date = [[NSDate alloc] init];
    self.petLabel.text = self.pet.name;
    self.activityLabel.text = self.activity.name;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (float)getLightenedValue:(NSNumber *) color {
    return (color.integerValue + (0.8 * (255 - color.integerValue))) / 255;
}

- (void)setPet:(Pet *)pet {
    _pet = pet;
    
    self.petLabel.text = pet.name;
}

- (void)setActivity:(Activity *)activity {
    _activity = activity;
    
    float red = [self getLightenedValue:self.activity.bgred];
    float green = [self getLightenedValue:self.activity.bggreen];
    float blue = [self getLightenedValue:self.activity.bgblue];
    
    UIColor *bgColor = [[UIColor alloc] initWithRed:red
                                         green:green
                                          blue:blue
                                         alpha:1];
        
    
    self.view.backgroundColor = bgColor;
    
    self.activityLabel.text = activity.name;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
