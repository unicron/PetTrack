//
//  PTStatsTableViewCell.h
//  PetTracker
//
//  Created by Hannemann on 4/3/14.
//  Copyright (c) 2014 Hannemann. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PTStatsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *weekLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;

@end
