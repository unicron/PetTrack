//
//  PetActivity.h
//  PetTracker
//
//  Created by Hannemann on 3/24/14.
//  Copyright (c) 2014 Hannemann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PetActivity : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * date;

@end
