//
//  PTRecordActivityViewController.h
//  PetTracker
//
//  Created by Hannemann on 4/13/14.
//  Copyright (c) 2014 Hannemann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Pet.h"
#import "Activity.h"

@interface PTRecordActivityViewController : UIViewController
@property (strong, nonatomic) Pet *pet;
@property (strong, nonatomic) Activity *activity;

//out
@property (strong, nonatomic, readonly) PetActivity *returnPetActivity;
@end
