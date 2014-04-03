//
//  StatsCDTVC.h
//  PetTracker
//
//  Created by Hannemann on 3/25/14.
//  Copyright (c) 2014 Hannemann. All rights reserved.
//

#import "CoreDataTableViewController.h"

@interface StatsCDTVC : CoreDataTableViewController
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@end
