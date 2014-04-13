//
//  PTActivityTableViewController.h
//  PetTracker
//
//  Created by Hannemann on 4/12/14.
//  Copyright (c) 2014 Hannemann. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PTActivityTableViewController : UITableViewController
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@end
