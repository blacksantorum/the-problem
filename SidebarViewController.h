//
//  SidebarViewController.h
//  boxfan
//
//  Created by Chris Tibbs on 1/13/14.
//  Copyright (c) 2014 Chris Tibbs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface SidebarViewController : UITableViewController

@property (nonatomic,strong) User *loggedInUser;

@end
