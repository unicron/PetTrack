//
//  PTSettingsPetViewController.h
//  PetTracker
//
//  Created by Hannemann on 4/17/14.
//  Copyright (c) 2014 Hannemann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Pet.h"

@interface PTSettingsPetViewController : UIViewController
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) Pet *pet;

//out
@property (strong, nonatomic, readonly) Pet *returnPet;
@end
