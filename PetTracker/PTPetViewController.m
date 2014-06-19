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
#import "PTSettingsPetViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>


@interface PTPetViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate, UIActionSheetDelegate>
@property (strong, nonatomic) Pet *pet;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) NSMutableArray *pets;
@property (nonatomic) BOOL pageControlBeingUsed;
@property (strong, nonatomic) UIImagePickerController *imagePicker;
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
    
//    [self getOrCreatePets];
    [self setupScrollView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self getOrCreatePets];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupScrollView {
    //clear the scrollview first
    for (UIView *view in [self.scrollView subviews]) {
        [view removeFromSuperview];
    }
    
    // Generate content for our scroll view using the frame height and width as the reference point
    self.pageControlBeingUsed = NO;
    
    // Adjust scroll view content size, set background colour and turn on paging
    UIScrollView *scrollView = self.scrollView;
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * [self.pets count],
                                        scrollView.frame.size.height);
    
    scrollView.backgroundColor = [UIColor whiteColor];
    
    int ii = 0;
    for (Pet *pet in self.pets) {
        UIImage *image = [UIImage imageWithData:pet.picture];
        UIImageView *imageView = [[UIImageView alloc]
                                  initWithFrame:CGRectMake(((scrollView.frame.size.width) * ii),
                                                           0,
                                                           (scrollView.frame.size.width),
                                                           scrollView.frame.size.height)];
        
        imageView.userInteractionEnabled = NO;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.image = image;
        [scrollView addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(imageView.frame.origin.x,
                                                                   (imageView.frame.origin.y),
                                                                   imageView.frame.size.width,
                                                                   37)];
        
        label.text = pet.name;
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 2;
        label.backgroundColor = [[UIColor alloc] initWithWhite:1.0 alpha:0.6];
        [scrollView addSubview:label];
        
        ii++;
    }
    
    self.pageControl.numberOfPages = [self.pets count];
}

- (void)getOrCreatePets {
    NSManagedObjectContext *context = self.managedObjectContext;
    if (context) {
        //create or get a default Pet
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Pet"];
        request.predicate = nil;
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"order"
                                                                  ascending:YES]];
        
        NSError *error = nil;
        self.pets = [[NSMutableArray alloc] initWithArray:[context executeFetchRequest:request error:&error]];
        
        if (self.pets && [self.pets count] > 0) {
            self.pet = self.pets.firstObject;
            
        } else {
            if (self.isViewLoaded && self.view.window) {
                [self performSegueWithIdentifier:@"Initial Pet" sender:self];
            }
        }
    }
}

-(void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    _managedObjectContext = managedObjectContext;
    [self getOrCreatePets];
}

#pragma mark - Scrolling/Pages
- (void)setCurrentPet {
    Pet *pet = [self.pets objectAtIndex:self.pageControl.currentPage];
    self.pet = pet;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.pageControlBeingUsed = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.pageControlBeingUsed = NO;
}

- (IBAction)changePage {
    // update the scroll view to the appropriate page
    CGRect frame;
    frame.origin.x = self.scrollView.frame.size.width * self.pageControl.currentPage;
    frame.origin.y = 0;
    frame.size = self.scrollView.frame.size;
    [self.scrollView scrollRectToVisible:frame animated:YES];

    self.pageControlBeingUsed = YES;
    [self setCurrentPet];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.pageControlBeingUsed)
        return;
    
    // Update the page when more than 50% of the previous/next page is visible
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    if (page != self.pageControl.currentPage) {
        self.pageControl.currentPage = page;
        [self setCurrentPet];
    }
}

- (IBAction)done:(UIStoryboardSegue *)segue {
    //MyModalVC *vc = (MyModalVC *)segue.sourceViewController; // get results out of vc, which I presented
    [self getOrCreatePets];
    [self setupScrollView];
}

- (IBAction)donePet:(UIStoryboardSegue *)segue {
    PTSettingsPetViewController *view = (PTSettingsPetViewController *)segue.sourceViewController; // get results out of vc, which I presented
    Pet *pet = view.returnPet;
    
    NSManagedObjectContext *context = self.managedObjectContext;
    if (pet && context) {
        // Save the context.
        NSError *error = nil;
        if (![context save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        
        [self.pets addObject:pet];
        self.pet = pet;
    }
    
    [self setupScrollView];
}

#pragma mark - Camera Button
- (IBAction)cameraClicked:(id)sender {
    self.imagePicker = [[UIImagePickerController alloc] init];
    [self.imagePicker setDelegate:self];
    self.imagePicker.allowsEditing = NO;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                 delegate:self
                                                        cancelButtonTitle:@"Cancel"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"Take Photo", @"Choose Existing", nil];
        [actionSheet showInView:self.view];
        
    } else {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:self.imagePicker animated:YES completion:NULL];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = info[UIImagePickerControllerEditedImage];
    if (!image) image = info[UIImagePickerControllerOriginalImage];
    
    self.pet.picture = [NSData dataWithData:UIImagePNGRepresentation(image)];
    [self setupScrollView];
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else if (buttonIndex == 1) {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    } else if (buttonIndex == 2) {
        return;
    }

    [self presentViewController:self.imagePicker animated:YES completion:NULL];
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
        view.pet = self.pet;
        
    } else if ([segue.destinationViewController isKindOfClass:[PTSettingsNavigationViewController class]]) {
        PTSettingsNavigationViewController *view = (PTSettingsNavigationViewController *)segue.destinationViewController;
        view.managedObjectContext = self.managedObjectContext;
        
    } else if ([segue.destinationViewController isKindOfClass:[PTSettingsPetViewController class]]) {
        PTSettingsPetViewController *view = (PTSettingsPetViewController *)segue.destinationViewController;
        view.managedObjectContext = self.managedObjectContext;
    }
}

@end
