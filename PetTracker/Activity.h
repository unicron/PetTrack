//
//  Activity.h
//  PetTracker
//
//  Created by Hannemann on 4/16/14.
//  Copyright (c) 2014 Hannemann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Activity : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) NSNumber * bggreen;
@property (nonatomic, retain) NSNumber * bgred;
@property (nonatomic, retain) NSNumber * bgblue;
@property (nonatomic, retain) NSNumber * bgalpha;

@end
