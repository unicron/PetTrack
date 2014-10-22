//
//  PTBaseViewController.m
//  PetTracker
//
//  Created by Hannemann on 3/12/14.
//  Copyright (c) 2014 Hannemann. All rights reserved.
//

#import "ViewControllerHelper.h"
#import "Activity+Database.h"

@interface ViewControllerHelper ()

@end


@implementation ViewControllerHelper

+ (void)setBackground:(UIView *)view
{
	// Do any additional setup after loading the view, typically from a nib.
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"backgroundImage"]];
    backgroundView.alpha = 0.3;
    backgroundView.frame = view.bounds;
    [view addSubview:backgroundView];
    [view sendSubviewToBack:backgroundView];
}

+ (void)setRowHeightForTable:(UITableView *)table withCount:(int)count
{
    float rowHeight = (table.bounds.size.height - 60) / count;
    if (rowHeight > 44)
        table.rowHeight = rowHeight;
}

+ (void)resetContext:(NSManagedObjectContext *)context {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Pet"];
    NSArray *items = [context executeFetchRequest:request error:nil];
    for (id item in items)
         [context deleteObject:item];
    
    request = [NSFetchRequest fetchRequestWithEntityName:@"Activity"];
    items = [context executeFetchRequest:request error:nil];
    for (id item in items)
        [context deleteObject:item];
    
    request = [NSFetchRequest fetchRequestWithEntityName:@"PetActivity"];
    items = [context executeFetchRequest:request error:nil];
    for (id item in items)
        [context deleteObject:item];
    
    // Save the context.
    NSError *error;
    if (![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    [context reset];
}

+ (Pet *)createDefaultPetWithManagedObjectContextContext:(NSManagedObjectContext *)context {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Pet"];
    NSArray *pets = [context executeFetchRequest:request error:nil];
    
    Pet *pet;
    if ([pets count] == 0) {
        
        pet = [Pet create:nil inManagedObjectContext:context];
        pet.name = @"Zelda";
        pet.order = @0;
        
        UIImage *petImage = [UIImage imageNamed:@"Zelda.jpg"];
        pet.picture = [NSData dataWithData:UIImageJPEGRepresentation(petImage, 0.8)];
        
        // Save the context.
        NSError *error;
        if (![context save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    } else {
        pet = [pets firstObject];
    }
    
    return pet;
}

+ (void)createDefaultActivitiesWithManagedObjectContextContext:(NSManagedObjectContext *)context {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Activity"];
    NSArray *activities = [context executeFetchRequest:request error:nil];
    
    if ([activities count] == 0) {
        Activity *activity = [Activity create:nil inManagedObjectContext:context];
        activity.name = @"Walk";
        activity.order = @0;
        activity.bgred = @0;
        activity.bggreen = @128;
        activity.bgblue = @128;
        activity.bgalpha = @0.8;
        
        activity = [Activity create:nil inManagedObjectContext:context];
        activity.name = @"Nap";
        activity.order = @1;
        activity.bgred = @255;
        activity.bggreen = @128;
        activity.bgblue = @0;
        activity.bgalpha = @0.8;
        
        activity = [Activity create:nil inManagedObjectContext:context];
        activity.name = @"Meal";
        activity.order = @2;
        activity.bgred = @64;
        activity.bggreen = @0;
        activity.bgblue = @128;
        activity.bgalpha = @0.8;
        
        activity = [Activity create:nil inManagedObjectContext:context];
        activity.name = @"Snack";
        activity.order = @3;
        activity.bgred = @128;
        activity.bggreen = @0;
        activity.bgblue = @0;
        activity.bgalpha = @0.8;
        
        activity = [Activity create:nil inManagedObjectContext:context];
        activity.name = @"Potty #1";
        activity.order = @4;
        activity.bgred = @25;
        activity.bggreen = @25;
        activity.bgblue = @25;
        activity.bgalpha = @0.8;
        
        activity = [Activity create:nil inManagedObjectContext:context];
        activity.name = @"Potty #2";
        activity.order = @5;
        activity.bgred = @0;
        activity.bggreen = @0;
        activity.bgblue = @255;
        activity.bgalpha = @0.8;
        
        activity = [Activity create:nil inManagedObjectContext:context];
        activity.name = @"Playtime";
        activity.order = @6;
        activity.bgred = @204;
        activity.bggreen = @102;
        activity.bgblue = @255;
        activity.bgalpha = @0.8;
        
        activity = [Activity create:nil inManagedObjectContext:context];
        activity.name = @"Sick";
        activity.order = @7;
        activity.bgred = @255;
        activity.bggreen = @102;
        activity.bgblue = @102;
        activity.bgalpha = @0.8;
        
        
        // Save the context.
        NSError *error;
        if (![context save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
