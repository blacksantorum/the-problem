//
//  boxfanAppDelegate.m
//  boxfan
//
//  Created by Chris Tibbs on 12/15/13.
//  Copyright (c) 2013 Chris Tibbs. All rights reserved.
//

#import "boxfanAppDelegate.h"
#import <Parse/Parse.h>
#import "Auth.h"
#import <PKRevealController/PKRevealController.h>
#import "BoxingScheduleVC.h"
#import "SidebarViewController.h"

@interface boxfanAppDelegate() <PKRevealing>

@property (nonatomic,strong,readwrite) PKRevealController *revealController;

@end

@implementation boxfanAppDelegate

-(void)doParseInitialization
{
    [Parse setApplicationId:@"1B14Hx2kPtRNvaupWjUNlmwPrJOsgZQ6qJv5tUDF"
                  clientKey:@"ygFW72dJh6tk3jbTxcEQoFbbROXRSIxaqldcv9Ik"];
    [PFTwitterUtils initializeWithConsumerKey:@"TK2igjpRfDN283wGr77Q"
                               consumerSecret:@"0ju7zB7dl67YsReYmPosJKWVsUbTaLZFiM01CP8Fghs"];
}

-(void)logOut
{
    [PFUser logOut];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"User"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSData *)encodedUserFromDefaults
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"User"];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self doParseInitialization];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // front
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *frontNavController = [storyboard instantiateViewControllerWithIdentifier:@"ScheduleNav"];
    // UINavigationController *frontNavController = [[UINavigationController alloc] initWithRootViewController:scheduleView];
    
    // left
    SidebarViewController *sideBarController = [[SidebarViewController alloc] initWithNibName:@"SidebarViewController" bundle:nil];
    
    if ([self encodedUserFromDefaults]) {
        User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData:[self encodedUserFromDefaults]];
        sideBarController.user = user;
    }
    
    self.revealController = [PKRevealController revealControllerWithFrontViewController:frontNavController leftViewController:sideBarController];
    
    self.revealController.delegate = self;
    self.revealController.animationDuration = 0.25;
    
    self.window.rootViewController = self.revealController;
    
    // [self logOut];
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

@end
