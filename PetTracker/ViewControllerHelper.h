//
//  PTBaseViewController.h
//  PetTracker
//
//  Created by Hannemann on 3/12/14.
//  Copyright (c) 2014 Hannemann. All rights reserved.
//

#import "Pet+Database.h"

@interface ViewControllerHelper : NSObject
+ (void)setBackground:(UIView *)view;
+ (void)setRowHeightForTable:(UITableView *)table withCount:(int)count;
+ (void)resetContext:(NSManagedObjectContext *)context;
+ (Pet *)createDefaultPetWithManagedObjectContextContext:(NSManagedObjectContext *)context;
+ (void)createDefaultActivitiesWithManagedObjectContextContext:(NSManagedObjectContext *)context;
@end
