
//  AppDelegate.m
//  Bttendance
//
//  Created by H AJE on 2013. 11. 7..
//  Copyright (c) 2013년 Bttendance. All rights reserved.
//

#import "AppDelegate.h"
#import <AudioToolbox/AudioToolbox.h>
#import "ProfileViewController.h"
#import "CourseDetailViewController.h"
#import "SideMenuViewController.h"
#import "CatchPointViewController.h"
#import "NoCourseViewController.h"
#import "BTUserDefault.h"
#import <Crashlytics/Crashlytics.h>
#import <AFNetworking/AFNetworking.h>
#import "BTAPIs.h"
#import "UIColor+Bttendance.h"
#import "PushNoti.h"
#import "BTNotification.h"
#import "AttendanceAgent.h"
#import "SocketAgent.h"
#import <Realm/Realm.h>

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Crashlytics startWithAPIKey:@"933280081941175a775ecfe701fefa562b7f8a01"];
    
    NSDictionary* barButtonItemAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:16.0],
                                              NSForegroundColorAttributeName: [UIColor white:1.0],
                                              };
    [[UIBarButtonItem appearanceWhenContainedIn: [UINavigationController class], nil] setTitleTextAttributes:barButtonItemAttributes
                                                                                                    forState:UIControlStateNormal];
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        [[UINavigationBar appearance] setTintColor:[UIColor navy:1.0]];
    } else {
        [[UINavigationBar appearance] setBarTintColor:[UIColor navy:1.0]];
    }
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    User *user = [BTUserDefault getUser];
    if(user == nil
       || user.email == nil
       || user.password == nil) {
        [BTUserDefault clear];
        CatchPointViewController *catchview = [[CatchPointViewController alloc] initWithNibName:@"CatchPointViewController" bundle:nil];
        self.topController = catchview;
        UINavigationController *navcontroller = [[UINavigationController alloc] initWithRootViewController:catchview];
        navcontroller.navigationBarHidden = YES;
        self.window.rootViewController = navcontroller;
    } else {
        SideMenuViewController *sideview = [[SideMenuViewController alloc] initByItSelf];
        self.topController = sideview;
        self.window.rootViewController = sideview;
    }
    
    [self.window makeKeyAndVisible];
  
    if([[[UIDevice currentDevice] systemVersion] floatValue] >=7){
        [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
        application.applicationIconBadgeNumber = 0;
    }
    
    NSLog(@"TIME");
    RLMRealm *realm = [RLMRealm inMemoryRealmWithIdentifier:@"BTTENDANCE"];
    RLMNotificationToken *token = [realm addNotificationBlock:^(NSString *notification, RLMRealm *realm) {
        NSLog(@"Notification : %@", notification);
        NSLog(@"Realm : %@", realm);
    }];
    
    
//    [realm beginWriteTransaction];
//    User *useruser = [[User alloc] initWithObject:@{@"id" : @0,
//                                                    @"email" : @"contact@thefinestartist.com",
//                                                    @"password" : @"pass",
//                                                    @"locale" : @"en",
//                                                    @"full_name" : @"Tae Hwan Kim",
//                                                    @"questions_count" : @0}];
//    
//    SimpleCourse *coursecourse = [[SimpleCourse alloc] initWithObject:@{@"id" : @0,
//                                                                        @"name" : @"Typography"}];
//    [useruser.supervising_courses addObject:coursecourse];
//    [useruser.attending_courses addObject:coursecourse];
//    
//    User *useruser1 = [User createOrUpdateInDefaultRealmWithObject:@{@"id" : @1,
//                                                    @"email" : @"contact@thefinestartist.com",
//                                                    @"password" : @"pass",
//                                                    @"locale" : @"en",
//                                                    @"full_name" : @"Tae Hwan Kim",
//                                                    @"questions_count" : @0}];
//    
////    SimpleCourse *coursecourse1 = [[SimpleCourse alloc] initWithObject:@{@"id" : @1,
////                                                                        @"name" : @"Typography"}];
////    [useruser1.supervising_courses addObject:coursecourse1];
////    [useruser1.attending_courses addObject:coursecourse1];
////    [realm addOrUpdateObject:useruser1];
//    NSLog(@"TIME");
//    [realm commitWriteTransaction];
    
//    for (NSInteger idx1 = 0; idx1 < 50; idx1++) {
//        [realm beginWriteTransaction];
//        for (NSInteger idx2 = 0; idx2 < 1000; idx2++) {
//            User *user = [[User alloc] initWithObject:@{@"id" : [NSNumber numberWithLong:idx1 * 1000 + idx2],
//                                                        @"email" : @"contact@thefinestartist.com",
//                                                        @"password" : @"pass",
//                                                        @"locale" : @"en",
//                                                        @"full_name" : @"Tae Hwan Kim",
//                                                        @"questions_count" : @0}];
//            
//            SimpleCourse *course = [[SimpleCourse alloc] initWithObject:@{@"id" : [NSNumber numberWithLong:idx1 * 1000 + idx2],
//                                                                          @"name" : @"Typography"}];
//            [user.supervising_courses addObject:course];
//            [user.attending_courses addObject:course];
//            [realm addOrUpdateObject:user];
//        }
//        NSLog(@"TIME");
//        [realm commitWriteTransaction];
//    }
    NSLog(@"TIME");
    RLMResults *rlmResults = [User allObjects];
    NSLog(@"TIME");
    NSLog(@"User : %ld", [rlmResults count]);
    NSLog(@"User : %@", [((User *)[rlmResults firstObject]).supervising_courses firstObject]);
    
    return YES;
}

#pragma RemoteNotification
-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"fail to register remote notification, %@", error);
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    NSMutableString *deviceId= [NSMutableString string];
    const unsigned char* ptr = (const unsigned char*)[deviceToken bytes];
    for(int i =0; i < 32; i++)
        [deviceId appendFormat:@"%02x", ptr[i]];
    NSString *device_token = [NSString stringWithString:deviceId];
    [BTAPIs updateNotificationKey:device_token
                          success:^(User *user) {
                          } failure:^(NSError *error) {
                          }];
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
    User *user = [BTUserDefault getUser];
    if(user == nil
       || user.email == nil
       || user.password == nil)
        return;
    
    if (application.applicationState == UIApplicationStateActive
        || application.applicationState == UIApplicationStateBackground)
        AudioServicesPlaySystemSound(1007);
    
    //attendance_started, attendance_on_going, attendance_checked, clicker_started, notice, added_as_manager, course_created
    PushNoti *noti = [[PushNoti alloc] initWithObject:userInfo];
    switch ([noti getPushNotiType]) {
        case PushNotiType_Attendance_Will_Start:
            break;
        case PushNotiType_Attendance_Started: {
            [[NSNotificationCenter defaultCenter] postNotificationName:FeedRefresh object:nil];
            
            [[AttendanceAgent sharedInstance] startAttdScanWithCourseIDs:[NSArray arrayWithObject:noti.course_id]];
            [[AttendanceAgent sharedInstance] alertForClassicBT];
            
            User *user = [BTUserDefault getUser];
            SimpleCourse *course = [user getCourse:[noti.course_id integerValue]];
            if(course == nil || [user supervising:course.id])
                return;
            
            if (application.applicationState == UIApplicationStateInactive) {
                NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:course, SimpleCourseInfo, nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:OpenCourse object:nil userInfo:data];
                return;
            }
            
            UIAlertView *alert;
            alert = [[UIAlertView alloc] initWithTitle:course.name
                                               message:noti.message
                                              delegate:self
                                     cancelButtonTitle:nil
                                     otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
            alert.tag = course.id;
            [alert show];
            break;
        }
        case PushNotiType_Attendance_On_Going: {
            [[NSNotificationCenter defaultCenter] postNotificationName:FeedRefresh object:nil];
            
            [[AttendanceAgent sharedInstance] startAttdScanWithCourseIDs:[NSArray arrayWithObject:noti.course_id]];
            [[AttendanceAgent sharedInstance] alertForClassicBT];
            break;
        }
        case PushNotiType_Attendance_Checked: {
            [[NSNotificationCenter defaultCenter] postNotificationName:FeedRefresh object:nil];
            
            User *user = [BTUserDefault getUser];
            SimpleCourse *course = [user getCourse:[noti.course_id integerValue]];
            if(course == nil || [user supervising:course.id])
                return;
            
            if (application.applicationState == UIApplicationStateInactive) {
                NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:course, SimpleCourseInfo, nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:OpenCourse object:nil userInfo:data];
                return;
            }
            
            UIAlertView *alert;
            alert = [[UIAlertView alloc] initWithTitle:course.name
                                               message:noti.message
                                              delegate:self
                                     cancelButtonTitle:nil
                                     otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
            alert.tag = 0;
            [alert show];
            break;
        }
        case PushNotiType_Clicker_Started: {
            [[NSNotificationCenter defaultCenter] postNotificationName:FeedRefresh object:nil];
            
            User *user = [BTUserDefault getUser];
            SimpleCourse *course = [user getCourse:[noti.course_id integerValue]];
            if(course == nil || [user supervising:course.id])
                return;
            
            if (application.applicationState == UIApplicationStateInactive) {
                NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:course, SimpleCourseInfo, nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:OpenCourse object:nil userInfo:data];
                return;
            }
            
            UIAlertView *alert;
            alert = [[UIAlertView alloc] initWithTitle:course.name
                                               message:noti.message
                                              delegate:self
                                     cancelButtonTitle:nil
                                     otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
            alert.tag = course.id;
            [alert show];
            break;
        }
        case PushNotiType_Clicker_On_Going: {
            [[NSNotificationCenter defaultCenter] postNotificationName:FeedRefresh object:nil];
            break;
        }
        case PushNotiType_Notice_Created: {
            [[NSNotificationCenter defaultCenter] postNotificationName:FeedRefresh object:nil];
            
            User *user = [BTUserDefault getUser];
            SimpleCourse *course = [user getCourse:[noti.course_id integerValue]];
            if(course == nil || [user supervising:course.id])
                return;
            
            if (application.applicationState == UIApplicationStateInactive) {
                NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:course, SimpleCourseInfo, nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:OpenCourse object:nil userInfo:data];
                return;
            }
            
            UIAlertView *alert;
            alert = [[UIAlertView alloc] initWithTitle:course.name
                                               message:noti.message
                                              delegate:self
                                     cancelButtonTitle:nil
                                     otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
            alert.tag = course.id;
            [alert show];
            break;
        }
        case PushNotiType_Notice_Updated:
            break;
        case PushNotiType_Curious_Commented:
            break;
        case PushNotiType_Added_As_Manager: {
            [BTAPIs autoSignInInSuccess:^(User *user) {
                
                SimpleCourse *course = [user getCourse:[noti.course_id integerValue]];
                if(course == nil)
                    return;
                
                if (application.applicationState == UIApplicationStateInactive) {
                    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:course, SimpleCourseInfo, nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:OpenCourse object:nil userInfo:data];
                    return;
                }
                
                [[SocketAgent sharedInstance] socketConnectToServer];
                
                UIAlertView *alert;
                alert = [[UIAlertView alloc] initWithTitle:course.name
                                                   message:noti.message
                                                  delegate:self
                                         cancelButtonTitle:nil
                                         otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
                alert.tag = course.id;
                [alert show];
                
            } failure:^(NSError *error) {
            }];
            break;
        }
        case PushNotiType_Course_Created:
            break;
        case PushNotiType_Etc:
        default:
            break;
    }
}

#pragma UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 0)
        return;

    SimpleCourse *course = [[BTUserDefault getUser] getCourse:alertView.tag];
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:course, SimpleCourseInfo, nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:OpenCourse object:nil userInfo:data];
}

#pragma StatusBar
- (void)application:(UIApplication *)application didChangeStatusBarFrame:(CGRect)oldStatusBarFrame {

}

#pragma Background
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
    NSLog(@"applicationDidEnterBackground");
    
    
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
    [self.topController viewWillAppear:YES];
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
