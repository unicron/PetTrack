//
//  StatsCDTVC.h
//  PetTracker
//
//  Created by Hannemann on 3/25/14.
//  Copyright (c) 2014 Hannemann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Pet.h"

@interface StatsTableViewController : UITableViewController
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) Pet *pet;
@end
