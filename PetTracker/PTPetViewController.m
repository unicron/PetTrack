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
@property (strong, nonatomic) NSMutableArray *pets;
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
    [self getOrCreatePets:context];
    
    // Adjust scroll view content size, set background colour and turn on paging
    UIScrollView *scrollView = self.scrollView;
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * [self.pets count],
                                        scrollView.frame.size.height);
    scrollView.pagingEnabled=YES;
    scrollView.backgroundColor = [UIColor whiteColor];
    
    int ii = 0;
    for (Pet *pet in self.pets) {
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
        label.backgroundColor = [[UIColor alloc] initWithWhite:1.0 alpha:0.5];
        [scrollView addSubview:label];
        
        ii++;
    }
    
    self.pageControl.numberOfPages = [self.pets count];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getOrCreatePets:(NSManagedObjectContext *)context {
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
            Pet *pet = [Pet create:nil inManagedObjectContext:context];
            pet.name = @"Zelda";
            pet.order = @0;
            
            UIImage *petImage = [UIImage imageNamed:@"IMG_1272.jpg"];
            pet.picture = [NSData dataWithData:UIImagePNGRepresentation(petImage)];
            
            // Save the context.
            if (![context save:&error]) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                abort();
            }
            
            [self.pets addObject:pet];
            self.pet = pet;
        }
    }
}

-(void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    _managedObjectContext = managedObjectContext;
    
    [self getOrCreatePets:managedObjectContext];
}

- (void)setCurrentPet {
    Pet *pet = [self.pets objectAtIndex:self.pageControl.currentPage];
    self.pet = pet;
}

#pragma mark - Scrolling/Pages
- (IBAction)changePage {
    // update the scroll view to the appropriate page
    CGRect frame;
    frame.origin.x = self.scrollView.frame.size.width * self.pageControl.currentPage;
    frame.origin.y = 0;
    frame.size = self.scrollView.frame.size;
    [self.scrollView scrollRectToVisible:frame animated:YES];

    [self setCurrentPet];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
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
}

#pragma mark - Camera Button
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
