//
//  PTSettingsPetViewController.m
//  PetTracker
//
//  Created by Hannemann on 4/17/14.
//  Copyright (c) 2014 Hannemann. All rights reserved.
//

#import "PTSettingsPetViewController.h"
#import "Pet+Database.h"
#import "PTPetViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface PTSettingsPetViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (weak, nonatomic) IBOutlet UINavigationItem *navTitle;
@property (strong, nonatomic) UIImagePickerController *imagePicker;
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
    
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
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
    if (!image)
        image = info[UIImagePickerControllerOriginalImage];
    
    self.pet.picture = [NSData dataWithData:UIImageJPEGRepresentation(image, 0.8)];
    self.imageView.image = image;
    
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

- (void)setPropertiesOnPet:(Pet *)pet
{
    pet.name = self.nameText.text;
    pet.picture = [NSData dataWithData:UIImageJPEGRepresentation(self.imageView.image, 1.0)];
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Unwind Done"]) {
        if (self.pet) {
            [self setPropertiesOnPet:self.pet];
            
        } else {
            NSManagedObjectContext *context = self.managedObjectContext;
            Pet *newPet = [Pet create:nil inManagedObjectContext:context];
            [self setPropertiesOnPet:newPet];
        }
        
    } else if ([segue.identifier isEqualToString:@"Unwind Delete"] && self.pet) {
        NSManagedObjectContext *context = self.managedObjectContext;
        [context deleteObject:self.pet];
        self.pet = nil;
        
    } else if ([segue.identifier isEqualToString:@"Unwind Cancel"]) {
        [self.managedObjectContext rollback];
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"Unwind Done"]) {
        BOOL shouldSave = NO;
        NSMutableString *msg = [[NSMutableString alloc] init];
        
        if ([self.nameText.text length]) {
            shouldSave = YES;
        
//            if (!self.imageView.image) {
//                shouldSave = NO;
//                [msg setString:@"Please choose a picture for your Pet"];
//            }
            
        } else {
            [msg setString:@"Please enter a name for your Pet"];
        }
        
        if (shouldSave) {
            return YES;
        
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Edit Pet"
                                                            message:msg
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
