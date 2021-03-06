//
//  PTActivityTableViewController.h
//  PetTracker
//
//  Created by Hannemann on 4/12/14.
//  Copyright (c) 2014 Hannemann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Pet.h"
#import "CoreDataTableViewController.h"

@interface PTActivityTableViewController : CoreDataTableViewController
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) Pet *pet;
@end
