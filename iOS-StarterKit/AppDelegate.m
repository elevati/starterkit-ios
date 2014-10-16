//
//  AppDelegate.m
//  iOS-StarterKit
//
//  Created by Rakesh B on 15/09/14.
//  Copyright (c) 2014 Elevati. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate
@synthesize isInternetConnectionAvailable = isInternetConnectionAvailable;
@synthesize objMasterViewController = objMasterViewController;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize dicDeleteAdvertisement = dicDeleteAdvertisement;
@synthesize dicAdvertisement = dicAdvertisement;

#pragma Application Life Cycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    dicAdvertisement = [[NSMutableDictionary alloc] init];
    dicDeleteAdvertisement = [[NSMutableDictionary alloc] init];
    
    [self inititalizeRechability];
    
    // Set the App ID for your app
    [[Harpy sharedInstance] setAppID:[NSString stringWithFormat:@"%d",AppStore_Id]];
    [[Harpy sharedInstance] setAppName:kAppName];
    [[Harpy sharedInstance] setAlertType:HarpyAlertTypeForce];
    [[Harpy sharedInstance] checkVersion];
    
     [self.navigationController.navigationBar setBarTintColor:[[Global defaultGlobal] getUIColorObjectFromHexString:@"CE3A30" alpha:1]];
    
    if(IS_IPAD)
        objMasterViewController = [[MasterViewController alloc] initWithNibName:iPadMasterView bundle:nil];
    else
        objMasterViewController = [[MasterViewController alloc] initWithNibName:iPhoneMasterView bundle:nil];
    
    UINavigationController *rootNavigationViewController = [[UINavigationController alloc]initWithRootViewController:objMasterViewController];
    rootNavigationViewController.navigationBarHidden = NO;
    [rootNavigationViewController.navigationBar setBarTintColor:[[Global defaultGlobal]getUIColorObjectFromHexString:@"CE3A30" alpha:1]];
    rootNavigationViewController.navigationBar
    .tintColor = [UIColor whiteColor];
    [rootNavigationViewController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    rootNavigationViewController.navigationBar.translucent = NO;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.window.rootViewController = rootNavigationViewController;
    [self.window makeKeyAndVisible];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma Initializing Rechability

//Implements reachability class
-(void)inititalizeRechability
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    
    Reachability * reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    reach.reachableBlock = ^(Reachability * reachability)
    {
        //If internet connection is available
        dispatch_async(dispatch_get_main_queue(), ^{
            isInternetConnectionAvailable = true;
        });
    };
    
    reach.unreachableBlock = ^(Reachability * reachability)
    {
        //If internet connection is not available
        dispatch_async(dispatch_get_main_queue(), ^{
            isInternetConnectionAvailable = false;
            /*if ([self hasInternet]) {
                isInternetConnectionAvailable = true;
            }*/
        });
    };
    [reach startNotifier];
}

//Added observer for ReachabilityChangedNotification
-(void)reachabilityChanged:(NSNotification*)note
{
    Reachability *reach = [note object];
    if([reach isReachable])
        isInternetConnectionAvailable = true;
    else
        isInternetConnectionAvailable = false;
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"StarterKitModel" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"StarterKit.sqlite"];
    
    NSLog(@"storeURL - %@",[storeURL absoluteString]);
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
       
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         */
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


#pragma mark - Private Methods


-(void)initializeGoogleAnalytics
{
    // Optional: automatically send uncaught exceptions to Google Analytics.
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = Analytics_Dispatch_Time;
    
    // Optional: set Logger to VERBOSE for debug information.
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
    
    // Initialize tracker. Replace with your tracking ID.
    [[GAI sharedInstance] trackerWithTrackingId:Google_Analytics_ID];
}


// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

+ (void)initialize
{
    NSString *appBundleIdentifier = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"];
    
    //set the bundle ID. normally you wouldn't need to do this
    //as it is picked up automatically from your Info.plist file
    //but we want to test with an app that's actually on the store
    [iRate sharedInstance].applicationBundleID = appBundleIdentifier;
    [iRate sharedInstance].onlyPromptIfLatestVersion = NO;
    [iRate sharedInstance].appStoreID = AppStore_Id;
    
    //below property is used for testing the "Rate this app feature in development mode"
    //[iRate sharedInstance].previewMode = YES;
    
    //set events count (default is 20)
    [iRate sharedInstance].eventsUntilPrompt = 20;
    
    //disable minimum day limit and reminder periods
    [iRate sharedInstance].daysUntilPrompt = 2;
    [iRate sharedInstance].remindPeriod = 1;
}

@end
