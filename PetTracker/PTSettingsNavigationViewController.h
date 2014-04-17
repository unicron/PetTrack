//
//  PTViewController.h
//  PetTracker
//
//  Created by Hannemann on 4/16/14.
//  Copyright (c) 2014 Hannemann. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PTSettingsNavigationViewController : UINavigationController
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@end
