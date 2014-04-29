//
//  PTBaseViewController.h
//  PetTracker
//
//  Created by Hannemann on 3/12/14.
//  Copyright (c) 2014 Hannemann. All rights reserved.
//

@interface ViewControllerHelper : NSObject
+ (void)setBackground:(UIView *)view;
+ (void)setRowHeightForTable:(UITableView *)table withCount:(int)count;
+ (void)createDefaultActivitiesWithManagedObjectContextContext:(NSManagedObjectContext *)context;

@end
