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
#import "StatsTableViewController.h"
#import "PTSettingsNavigationViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>


@interface PTPetViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate>
@property (strong, nonatomic) Pet *pet;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
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
    
    // Generate content for our scroll view using the frame height and width as the reference point    
    NSManagedObjectContext *context = self.managedObjectContext;
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Pet" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSError *error = nil;
    NSArray *array = [context executeFetchRequest:request error:&error];
    
    // Adjust scroll view content size, set background colour and turn on paging
    UIScrollView *scrollView = self.scrollView;
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * [array count],
                                        scrollView.frame.size.height);
    scrollView.pagingEnabled=YES;
    scrollView.backgroundColor = [UIColor whiteColor];
    
    int ii = 0;
    for (Pet *pet in array) {
        UIImage *image = [UIImage imageWithData:pet.picture];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(((scrollView.frame.size.width) * ii) + 5,
                                                                               0,
                                                                               (scrollView.frame.size.width) - 10,
                                                                               scrollView.frame.size.height)];
        
        imageView.image = image;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [scrollView addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(imageView.center.x - 50,
                                                                   imageView.center.y,
                                                                   100,
                                                                   25)];
        
        label.text = pet.name;
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 2;
        [scrollView addSubview:label];
        
        ii++;
    }
    
    self.pageControl.numberOfPages = [array count];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    _managedObjectContext = managedObjectContext;
    
    //create or get a default Pet
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Pet" inManagedObjectContext:managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSError *error = nil;
    NSArray *array = [managedObjectContext executeFetchRequest:request error:&error];
    
    if (array && [array count] > 0) {
        self.pet = array.firstObject;
        
    } else {
        Pet *pet = [Pet create:nil inManagedObjectContext:managedObjectContext];
        pet.name = @"Zelda";
        
        UIImage *petImage = [UIImage imageNamed:@"IMG_1272.jpg"];
        pet.picture = [NSData dataWithData:UIImagePNGRepresentation(petImage)];
        
        // Save the context.
        if (![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        
        self.pet = pet;
    }
}

- (IBAction)changePage {
    // update the scroll view to the appropriate page
    CGRect frame;
    frame.origin.x = self.scrollView.frame.size.width * self.pageControl.currentPage;
    frame.origin.y = 0;
    frame.size = self.scrollView.frame.size;
    [self.scrollView scrollRectToVisible:frame animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // Update the page when more than 50% of the previous/next page is visible
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
}

- (IBAction)done:(UIStoryboardSegue *)segue {
    //MyModalVC *vc = (MyModalVC *)segue.sourceViewController; // get results out of vc, which I presented
}

- (IBAction)cameraClicked:(id)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.allowsEditing = YES;
    
    [self presentViewController:imagePicker animated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = info[UIImagePickerControllerEditedImage];
    if (!image) image = info[UIImagePickerControllerOriginalImage];
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[PTActivityTableViewController class]]) {
        PTActivityTableViewController *view = (PTActivityTableViewController *)segue.destinationViewController;
        view.managedObjectContext = self.managedObjectContext;
        view.pet = self.pet;
        
    } else if ([segue.destinationViewController isKindOfClass:[StatsTableViewController class]]) {
        StatsTableViewController *view = (StatsTableViewController *)segue.destinationViewController;
        view.managedObjectContext = self.managedObjectContext;
        
    } else if ([segue.destinationViewController isKindOfClass:[PTSettingsNavigationViewController class]]) {
        PTSettingsNavigationViewController *view = (PTSettingsNavigationViewController *)segue.destinationViewController;
        view.managedObjectContext = self.managedObjectContext;
        
    }
}

@end
