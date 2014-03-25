//
//  PTFirstViewController.h
//  PetTracker
//
//  Created by Hannemann on 3/11/14.
//  Copyright (c) 2014 Hannemann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VCHelper.h"

@interface ActivityVC : UIViewController
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@end
