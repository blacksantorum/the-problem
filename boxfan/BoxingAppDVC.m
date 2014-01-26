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

@interface BoxingAppDVC ()

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;


@end

@implementation BoxingAppDVC

-(User *)loggedInUser
{
    BoxFanRevealController *bfrc= (BoxFanRevealController *)self.revealController;
    return bfrc.loggedInUser;
}

-(IBAction)userClickedShowSettings:(id)sender
{
    [self showSettingsMenu];
}

- (void)showSettingsMenu
{
    [[self revealController] showViewController:[[self revealController] leftViewController]];
}

-(void)refresh
{
    [self.activityIndicator startAnimating];

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
                // NSLog(@"%@",self.JSONarray);
                [self configureDataSource];
                [self.tableView reloadData];
                [self.activityIndicator stopAnimating];
                self.activityIndicator.hidden = YES;
            }
        }
    }];
}

-(void)configureDataSource
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
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refresh];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}


@end
