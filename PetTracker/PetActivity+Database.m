//
//  PetActivity+Database.m
//  PetTracker
//
//  Created by Hannemann on 3/24/14.
//  Copyright (c) 2014 Hannemann. All rights reserved.
//

#import "PetActivity+Database.h"

@implementation PetActivity (Database)
+ (PetActivity *)create:(PetActivity *)pa inManagedObjectContext:(NSManagedObjectContext *)context {
    PetActivity *newPa = [NSEntityDescription insertNewObjectForEntityForName:@"PetActivity"
                                                   inManagedObjectContext:context];
    
    return newPa;
}
@end
