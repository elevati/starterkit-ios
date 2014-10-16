//
//  AppDelegate.h
//  iOS-StarterKit
//
//  Created by Rakesh B on 15/09/14.
//  Copyright (c) 2014 Elevati. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterViewController.h"
#import "Reachability.h"
#import "Global.h"
#import "Harpy.h"
#import "iRate.h"
#import "GAI.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) MasterViewController *objMasterViewController;

@property (nonatomic, assign) BOOL isInternetConnectionAvailable;

@property (nonatomic, strong) NSMutableDictionary *dicAdvertisement;
@property (nonatomic, strong) NSMutableDictionary *dicDeleteAdvertisement;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end
