//
//  Activity+Database.h
//  PetTracker
//
//  Created by Hannemann on 4/16/14.
//  Copyright (c) 2014 Hannemann. All rights reserved.
//

#import "Activity.h"

@interface Activity (Database)
+ (Activity *)create:(Activity *)activity inManagedObjectContext:(NSManagedObjectContext *)context;
@end
