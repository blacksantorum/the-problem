//
//  BoxingAppDVC.m
//  boxfan
//
//  Created by Chris Tibbs on 1/8/14.
//  Copyright (c) 2014 Chris Tibbs. All rights reserved.
//

#import "BoxingAppDVC.h"
#import "URLS.h"
#import <Parse/Parse.h>
#import <PKRevealController/PKRevealController.h>
#import "BoxingScheduleVC.h"
#import "boxfanAppDelegate.h"

@interface BoxingAppDVC ()

@property (strong, nonatomic)  UIActivityIndicatorView *spinner;


@end

@implementation BoxingAppDVC

// carry Logged in user from RootViewController

- (User *)loggedInUser
{
    BoxFanRevealController *bfrc= (BoxFanRevealController *)self.revealController;
    return bfrc.loggedInUser;
}

// open side bar

- (IBAction)userClickedShowSettings:(id)sender
{
    [self showSettingsMenu];
}

- (void)showSettingsMenu
{
    [[self revealController] showViewController:[[self revealController] leftViewController]];
}

// make a call to the supplied URL, store the response in an Array of JSON objects

- (void)addActivityViewIndicator
{
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:self.spinner];
    self.spinner.center = self.view.center;
}

- (void)refresh
{
    [(boxfanAppDelegate *)[[UIApplication sharedApplication] delegate] setNetworkActivityIndicatorVisible:YES];
    [self addActivityViewIndicator];
    [self.spinner startAnimating];

    NSURLRequest *request = [NSURLRequest requestWithURL:self.urlForRequest];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            NSLog(@"Connection error: %@", connectionError);
        } else {
            NSError *error = nil;
            id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            if (error) {
                NSLog(@"JSON parsing error: %@", error);
            } else {
                self.JSONarray = (NSArray *)object;
                NSLog(@"%@",self.JSONarray);
                [self configureDataSource];
                [self.tableView reloadData];
                [self.spinner stopAnimating];
                [(boxfanAppDelegate *)[[UIApplication sharedApplication] delegate] setNetworkActivityIndicatorVisible:NO];
            }
        }
    }];
}

- (void)configureDataSource
{
    //override
}

- (void)doLogInStuff
{
    // override if necessary
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self refresh];
    self.navigationController.toolbarHidden = YES;
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

@end
