//
//  PTFirstViewController.h
//  PetTracker
//
//  Created by Hannemann on 3/11/14.
//  Copyright (c) 2014 Hannemann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PTViewControllerHelper.h"

@interface PTActivityViewController : UIViewController
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@end
