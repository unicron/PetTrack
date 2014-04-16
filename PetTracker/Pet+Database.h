//
//  Pet+Database.h
//  PetTracker
//
//  Created by Hannemann on 4/16/14.
//  Copyright (c) 2014 Hannemann. All rights reserved.
//

#import "Pet.h"

@interface Pet (Database)
+ (Pet *)create:(Pet *)pet inManagedObjectContext:(NSManagedObjectContext *)context;
@end
