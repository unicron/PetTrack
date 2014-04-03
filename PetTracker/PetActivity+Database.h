//
//  PetActivity+Database.h
//  PetTracker
//
//  Created by Hannemann on 3/24/14.
//  Copyright (c) 2014 Hannemann. All rights reserved.
//

#import "PetActivity.h"

@interface PetActivity (Database)
+ (PetActivity *)create:(PetActivity *)pa inManagedObjectContext:(NSManagedObjectContext *)context;
@end
