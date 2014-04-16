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
#import "Pet+Database.h"

@interface PTPetViewController ()
@property (strong, nonatomic) Pet *pet;
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
    
    NSManagedObjectContext *context = [self managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Pet" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSError *error = nil;
    NSArray *array = [context executeFetchRequest:request error:&error];
    
    if (array && [array count] > 0) {
        self.pet = array.firstObject;
    
    } else {
        Pet *pet = [Pet create:nil inManagedObjectContext:context];
        pet.name = @"Zelda";
        
        // Save the context.
        if (![context save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        
        self.pet = pet;
    }
    
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
        view.pet = self.pet;
    }
}

@end
