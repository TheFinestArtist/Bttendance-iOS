
//  AppDelegate.m
//  Bttendance
//
//  Created by H AJE on 2013. 11. 7..
//  Copyright (c) 2013년 Bttendance. All rights reserved.
//

#import "AppDelegate.h"
#import "CatchPointController.h"
#import "SignInController.h"
#import "SignUpController.h"
#import "ViewController.h"
#import "BTUserDefault.h"
#import <Crashlytics/Crashlytics.h>
#import <AFNetworking/AFNetworking.h>
#import "BTAPIs.h"

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Crashlytics startWithAPIKey:@"933280081941175a775ecfe701fefa562b7f8a01"];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    UINavigationController *navigationController;
    
    if([BTUserDefault getUser] != nil
       && [BTUserDefault getUsername] != nil
       && [BTUserDefault getPassword] != nil){
        firstview = [[CatchPointController alloc] initWithNibName:@"CatchPointController" bundle:nil];
    } else {
        firstview = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
    }
        
    // Navigation
    navigationController = [[UINavigationController alloc] initWithRootViewController:firstview];
    navigationController.navigationBarHidden = YES;
    self.window.rootViewController = navigationController;

    [self.window addSubview:navigationController.view];
    [self.window makeKeyAndVisible];
  
    if([[[UIDevice currentDevice] systemVersion] floatValue] >=7){
        [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
        application.applicationIconBadgeNumber = 0;
    }
    
    return YES;
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"fail to register remote notification, %@", error);
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    NSMutableString *deviceId= [NSMutableString string];
    const unsigned char* ptr = (const unsigned char*)[deviceToken bytes];
    for(int i =0; i < 32; i++)
        [deviceId appendFormat:@"%02x", ptr[i]];
    NSString *device_token = [NSString stringWithString:deviceId];
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    NSDictionary *noti = userInfo;
    
    if([[noti objectForKey:@"message"] isEqualToString:@"Attendance has been checked"]){
        AudioServicesPlaySystemSound(4095);
    } else {
        AudioServicesPlaySystemSound(1007);
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NEWMESSAGE" object:nil];
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
    
    application.applicationIconBadgeNumber = 0;
    
    
//    if ([[UIDevice currentDevice] respondsToSelector:@selector(isMultitaskingSupported)]) { //Check if our iOS version supports multitasking I.E iOS 4
//		if ([[UIDevice currentDevice] isMultitaskingSupported]) { //Check if device supports mulitasking
//            NSLog(@"background time : %f",[UIApplication sharedApplication].backgroundTimeRemaining);
//            __block UIBackgroundTaskIdentifier background_task;
//			background_task = [application beginBackgroundTaskWithExpirationHandler: ^ {
//				[application endBackgroundTask: background_task]; //Tell the system that we are done with the tasks
//				background_task = UIBackgroundTaskInvalid; //Set the task to be invalid
//				//System will be shutting down the app at any point in time now
//			}];
//            NSLog(@"background time : %f",[UIApplication sharedApplication].backgroundTimeRemaining);
//            
//			//Background tasks require you to use asyncrous tasks
//			dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//				//Perform your tasks that your application requires
//                NSLog(@"Running in the background!");
//                NSLog(@"background time : %f",[UIApplication sharedApplication].backgroundTimeRemaining);
//                sleep([UIApplication sharedApplication].backgroundTimeRemaining - 1.0f);
//                NSLog(@"Running in the background Ended!");
//				[application endBackgroundTask: background_task]; //End the task so the system knows that you are done with what you need to perform
//				background_task = UIBackgroundTaskInvalid; //Invalidate the background_task
//			});
//		}
//	}
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    application.applicationIconBadgeNumber = 0;
    [firstview viewWillAppear:YES];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self saveContext];
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
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Bttendance" withExtension:@"momd"];
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
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Bttendance.sqlite"];
    
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


#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
