//
//  BoxingAppDVC.h
//  boxfan
//
//  Created by Chris Tibbs on 1/8/14.
//  Copyright (c) 2014 Chris Tibbs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "BoxFanRevealController.h"

@interface BoxingAppDVC : UITableViewController

@property (strong,nonatomic) User *loggedInUser;
@property (strong,nonatomic) NSURL *urlForRequest;
@property (strong,nonatomic) NSArray *JSONarray;

-(void)configureDataSource;
- (void)showSettingsMenu;
-(void)refresh;

- (IBAction)userClickedShowSettings:(id)sender;

@end
