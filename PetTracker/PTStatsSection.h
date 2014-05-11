//
//  PTStatsSection.h
//  PetTracker
//
//  Created by Hannemann on 5/11/14.
//  Copyright (c) 2014 Hannemann. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PTStatsSection : NSObject
@property (strong, nonatomic) NSString *sectionName;
@property (strong, nonatomic) NSMutableArray *statsObjects;
@end
