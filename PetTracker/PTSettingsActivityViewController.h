//
//  PTSettingsActivityViewController.h
//  PetTracker
//
//  Created by Hannemann on 4/23/14.
//  Copyright (c) 2014 Hannemann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Activity.h"

@interface PTSettingsActivityViewController : UIViewController
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) Activity *activity;

//out
@property (strong, nonatomic, readonly) Activity *returnActivity;
@end
