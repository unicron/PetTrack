//
//  Pet+Database.m
//  PetTracker
//
//  Created by Hannemann on 4/16/14.
//  Copyright (c) 2014 Hannemann. All rights reserved.
//

#import "Pet+Database.h"

@implementation Pet (Database)
+ (Pet *)create:(Pet *)pet inManagedObjectContext:(NSManagedObjectContext *)context {
    Pet *newPet = [NSEntityDescription insertNewObjectForEntityForName:@"Pet"
                                                inManagedObjectContext:context];
    
    return newPet;
}
@end
