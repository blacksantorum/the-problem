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

@implementation boxfanAppDelegate

-(void)logOut
{
    [PFUser logOut];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"User"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSURL *)authURL
{
    return [NSURL URLWithString:@"http://the-boxing-app.herokuapp.com/auth/twitter"];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [Parse setApplicationId:@"1B14Hx2kPtRNvaupWjUNlmwPrJOsgZQ6qJv5tUDF"
                  clientKey:@"ygFW72dJh6tk3jbTxcEQoFbbROXRSIxaqldcv9Ik"];
    
    [PFTwitterUtils initializeWithConsumerKey:@"TK2igjpRfDN283wGr77Q"
                               consumerSecret:@"0ju7zB7dl67YsReYmPosJKWVsUbTaLZFiM01CP8Fghs"];
    
    
    // [self logOut];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSLog(@"%@",[defaults objectForKey:@"Token"]);

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
