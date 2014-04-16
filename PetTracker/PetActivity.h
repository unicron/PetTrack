//
//  PetActivity.h
//  PetTracker
//
//  Created by Hannemann on 4/16/14.
//  Copyright (c) 2014 Hannemann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Activity, Pet;

@interface PetActivity : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) Pet *pet;
@property (nonatomic, retain) Activity *activity;

@end
