//
//  PTSecondViewController.h
//  PetTracker
//
//  Created by Hannemann on 3/11/14.
//  Copyright (c) 2014 Hannemann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PTBaseViewController.h"

@interface PTHistoryViewController : PTBaseViewController
@property (strong, nonatomic) NSArray *historyFromParent;
@end
