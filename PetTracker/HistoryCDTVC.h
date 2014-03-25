//
//  PTHistoryTableViewController.h
//  PetTracker
//
//  Created by Hannemann on 3/14/14.
//  Copyright (c) 2014 Hannemann. All rights reserved.
//

#import "CoreDataTableViewController.h"

@interface HistoryCDTVC : CoreDataTableViewController
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSIndexPath *selectedIndexPath;
@end
