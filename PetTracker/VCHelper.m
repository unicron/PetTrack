//
//  PTBaseViewController.m
//  PetTracker
//
//  Created by Hannemann on 3/12/14.
//  Copyright (c) 2014 Hannemann. All rights reserved.
//

#import "VCHelper.h"

@interface VCHelper ()

@end

@implementation VCHelper

+ (void)setBackground:(UIView *)view
{
	// Do any additional setup after loading the view, typically from a nib.
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"backgroundImage"]];
    backgroundView.alpha = 0.3;
    backgroundView.frame = view.bounds;
    [view addSubview:backgroundView];
    [view sendSubviewToBack:backgroundView];
}

@end
