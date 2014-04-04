//
//  PTStatsObject.h
//  PetTracker
//
//  Created by Hannemann on 4/3/14.
//  Copyright (c) 2014 Hannemann. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PTStatsObject : NSObject
@property (strong, nonatomic) NSString *sectionName;
@property (nonatomic) NSInteger dayCount;
@property (nonatomic) NSInteger weekCount;
@property (nonatomic) NSInteger monthCount;
@end
