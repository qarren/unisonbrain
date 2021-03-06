//
//  UBAppDelegate.m
//  Unison Brain
//
//  Created by Kyle Warren on 1/30/13.
//  Copyright (c) 2013 Kyle Warren. All rights reserved.
//

#import "UBAppDelegate.h"

#import "UBRequest.h"
#import "UBBson.h"
#import "UBUser.h"

#import "UBHomeViewController.h"
#import "UBLoginViewController.h"

#import "UBCodeType.h"
#import "UBCode.h"
#import "UBSubject.h"
#import "UBStudent.h"
#import "UBTeacher.h"

@interface UBAppDelegate ()

@property (nonatomic) UINavigationController *mainNav;
@property (nonatomic) UIViewController *rootViewController;
@property (nonatomic) UBLoginViewController *loginViewController;
@property (nonatomic) UBHomeViewController *homeViewController;

@end

@implementation UBAppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // TEST METHOD: comment this usually
    //[self generateFakeData];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    _loginViewController = [[UBLoginViewController alloc] init];
    _homeViewController = [[UBHomeViewController alloc] init];
    _mainNav = [[UINavigationController alloc] initWithRootViewController:_homeViewController];
    

    
    [self.window setRootViewController:_mainNav];
    
    if (![UBUser currentUser].loggedIn) {
        [_mainNav presentViewController:_loginViewController animated:NO completion:nil];
        _rootViewController = _loginViewController;
        _mainNav.navigationBarHidden = YES;
    }
    else {
        _rootViewController = _homeViewController;
        [self fetchServerStuff];
    }
    
 
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(authenticated) name:kLoginSuccessNotifName object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(expired) name:kLoginExpiredNotifName object:nil];
    
    return YES;
}

- (void)authenticated
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_rootViewController == _loginViewController) {
            _mainNav.navigationBarHidden = NO;
            [_mainNav dismissViewControllerAnimated:YES completion:nil];
            _rootViewController = _homeViewController;
        }
    });
    [self fetchServerStuff];
    [_homeViewController reloadData];
}

- (void)expired
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_rootViewController != _loginViewController) {
            _mainNav.navigationBarHidden = YES;
            [_mainNav presentViewController:_loginViewController animated:YES completion:nil];
            _rootViewController = _loginViewController;
            //[_mainNav presentViewController:_loginViewController animated:YES completion:nil];
        }
    });
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
    // Saves changes in the application's managed object context before the application terminates.
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
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Unison_Brain" withExtension:@"momd"];
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
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Unison_Brain.sqlite"];
    
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

#pragma mark - Custom static methods

+ (NSManagedObjectContext *)moc
{
    return ((UBAppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
}

#pragma mark - Testing methods that whouldn't be used ever
- (void)fetchServerStuff
{
    [UBStudent fetchAll];
    [UBTeacher fetchAll];
    [UBSubject fetchAll];
    [UBCodeType fetchAll];
    //[UBCode fetchAll];
    //NSLog(@"people %@ %@", [UBStudent all], [UBTeacher all]);
    //NSLog(@"bsonid %@", [UBBson bsonId]);
    //NSLog(@"types %@", [UBCodeType all]);
    //NSLog(@"codes %@", [UBCode all]);
}

- (void)generateFakeData
{
    // dummy code to create a bunch of codes, students, subjects
    
    NSArray *types = @[@"Social",
                       @"Genre",
                       @"Decoding",
                       @"Comprehension"];
    
    for (NSString *name in types) {
        UBCodeType *type = [UBCodeType create];
        type.name = name;
    }

     
    NSArray *codes = @[
                       @[@"dinosaurs", @6],
                       @[@"monsters", @6],
                       @[@"dragons", @6],
                       @[@"peaches", @6],
                       @[@"timbre", @6],
                       @[@"biology", @6],
                       @[@"math", @7],
                       @[@"dream dust", @7],
                       @[@"dream station", @7],
                       @[@"octopus", @7],
                       @[@"toes", @7]
                       ];
    
    UBCode *code = nil;
    for (NSArray *arr in codes) {
        code = [UBCode create];
        code.name = arr[0];
        code.year = arr[1];
        UBCodeType *type = [UBCodeType all][0];
        code.codeType =  type; // setting type to a default....
    }
     
    
    NSArray *students = @[
                       @[@"Danny", @"Bowman"],
                       @[@"Kyle", @"Warren"],
                       @[@"Joe", @"Posner"],
                       @[@"Amy", @"Piller"],
                       ];
    
    UBStudent *student = nil;
    for (NSArray *arr in students) {
        student = [UBStudent create];
        student.fname = arr[0];
        student.lname = arr[1];
    }
     
    
    for (UBSubject *subject in [UBSubject all]) {
        [subject destroy];
    }
    

    NSArray *subjects = @[
                          @"English",
                          @"Math",
                          @"Science",
                          @"Art",
                          ];
    
    UBSubject *subject = nil;
    for (NSString *name in subjects) {
        subject = [UBSubject create];
        subject.name = name;
    }
     

    UBTeacher *teacher = [UBTeacher create];
    teacher.fname = @"Bob";
    teacher.lname = @"Teacher";

    
    [[UBAppDelegate moc] save:nil];
}

@end
