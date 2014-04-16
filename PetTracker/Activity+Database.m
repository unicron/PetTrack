//
//  Activity+Database.m
//  PetTracker
//
//  Created by Hannemann on 4/16/14.
//  Copyright (c) 2014 Hannemann. All rights reserved.
//

#import "Activity+Database.h"

@implementation Activity (Database)
+ (Activity *)create:(Activity *)pet inManagedObjectContext:(NSManagedObjectContext *)context {
    Activity *newActivity = [NSEntityDescription insertNewObjectForEntityForName:@"Activity"
                                                          inManagedObjectContext:context];
    
    return newActivity;
}
@end
