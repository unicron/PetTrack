//
//  PTViewController.m
//  PetTracker
//
//  Created by Hannemann on 4/16/14.
//  Copyright (c) 2014 Hannemann. All rights reserved.
//

#import "PTSettingsNavigationViewController.h"
#import "PTSettingsTableViewController.h"

@interface PTSettingsNavigationViewController ()

@end

@implementation PTSettingsNavigationViewController

-(void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    _managedObjectContext = managedObjectContext;
    
    PTSettingsTableViewController *controller = (PTSettingsTableViewController *)self.topViewController;
    controller.managedObjectContext = self.managedObjectContext;
}

@end
