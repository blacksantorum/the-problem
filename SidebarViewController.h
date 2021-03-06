//
//  SidebarViewController.h
//  boxfan
//
//  Created by Chris Tibbs on 1/13/14.
//  Copyright (c) 2014 Chris Tibbs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@protocol LogOutDelegate <NSObject>

- (void)logOut;

@end

@interface SidebarViewController : UITableViewController

@property (nonatomic,strong) User *loggedInUser;

@property (nonatomic,assign)id delegate;

@end
