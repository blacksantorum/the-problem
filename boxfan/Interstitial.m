//
//  Interstitial.m
//  boxfan
//
//  Created by Chris Tibbs on 1/16/14.
//  Copyright (c) 2014 Chris Tibbs. All rights reserved.
//

#import "Interstitial.h"
#import <AFNetworking/AFHTTPRequestOperationManager.h>

@interface Interstitial ()

@property BOOL loggedIn;

@end

@implementation Interstitial

@synthesize delegate;

-(void)signInWithRails:(User *)user
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = user.userDictionaryForSignIn;
    [manager POST:[URLS urlStringForRailsSignIn] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *userDictionary = responseObject;
        NSLog(@"Here's the user dictionary: %@", userDictionary);
        user.userID = [userDictionary valueForKeyPath:@"user.id"];
        NSLog(@"ID from dictionary: %@",[userDictionary valueForKeyPath:@"user.id"]);
        NSLog(@"User ID: %@",user.userID);
        NSLog(@"%@",[userDictionary valueForKeyPath:@"user.session_token"]);
        NSString *token = [userDictionary valueForKeyPath:@"user.session_token"];
        [self saveUserInDefaults:user withSessionToken:token];
        self.loggedIn = YES;
        if([delegate respondsToSelector:@selector(passUser:)]) {
            [delegate passUser:user];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

-(NSDictionary *)userDictionaryFromTwitter
{
    NSString *twitterScreenName = [PFTwitterUtils twitter].screenName;
    NSURL *verify = [NSURL URLWithString:[URLS urlStringForUsersTwitterWithScreenname:twitterScreenName]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:verify];
    [[PFTwitterUtils twitter] signRequest:request];
    NSURLResponse *response = nil;
    NSError *error;
    NSData *data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:&response
                                                     error:&error];
    
    NSDictionary* result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    return result;
}

-(void)saveUserInDefaults:(User *)user
         withSessionToken:(NSString *)token
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSData *encodedUser = [NSKeyedArchiver archivedDataWithRootObject:user];
    [defaults setObject:encodedUser forKey:@"User"];
    [defaults setObject:token forKey:@"Token"];
    [defaults synchronize];
}

// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [logInController dismissViewControllerAnimated:YES completion:nil];
    
    User *boxingAppUser = [[User alloc] initWithDictionary:[self userDictionaryFromTwitter]];
    
    [self signInWithRails:boxingAppUser];
}

// Sent to the delegate when the log in attempt fails.
- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    NSLog(@"Failed to log in...");
}

// Sent to the delegate when the log in screen is dismissed.
- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    NSLog(@"User dismissed the logInViewController");
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!self.loggedIn) {
        [self doLogInStuff];
    }
}

-(void)doLogInStuff
{
   // if (![PFUser currentUser]) {
        // If not logged in, we will show a PFLogInViewController
        PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init];
        
        // Customize the Log In View Controller
        logInViewController.delegate = self;
        // logInViewController.facebookPermissions = @[@"friends_about_me"];
        logInViewController.fields = PFLogInFieldsTwitter | PFLogInFieldsDismissButton; // Show Twitter login, Facebook login, and a Dismiss button.
        
        // Present Log In View Controller
        [self presentViewController:logInViewController animated:YES completion:NULL];
   // }
}

- (IBAction)continueButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
