//
//  PTSettingsPetViewController.m
//  PetTracker
//
//  Created by Hannemann on 4/17/14.
//  Copyright (c) 2014 Hannemann. All rights reserved.
//

#import "PTSettingsPetViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>


@interface PTSettingsPetViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UINavigationItem *navTitle;
@end


@implementation PTSettingsPetViewController

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
    
    [self setPet:self.pet];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setPet:(Pet *)pet {
    _pet = pet;
    
    if (pet) {
        if ([pet.name length])
            self.nameText.text = pet.name;
        
        if (pet.picture)
            self.imageView.image = [[UIImage alloc] initWithData:pet.picture];
    
    } else {
        self.navTitle.title = @"Add Pet";
        self.deleteButton.hidden = YES;
    }
}

- (IBAction)cancelClicked:(id)sender {
    self.pet = nil;
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)takePicture:(id)sender {
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
    
    self.imageView.image = image;
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)deletePet:(id)sender {
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    self.pet.name = self.nameText.text;
    self.pet.picture = [NSData dataWithData:UIImagePNGRepresentation(self.imageView.image)];
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([self.nameText.text length])
        return YES;
    
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Please enter a name for your Pet"
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
        [alert show];
        return NO;
    }
}

@end
