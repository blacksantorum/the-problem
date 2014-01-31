//
//  SidebarViewController.h
//  boxfan
//
//  Created by Chris Tibbs on 1/13/14.
//  Copyright (c) 2014 Chris Tibbs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "Interstitial.h"

@protocol LogOutDelegate <NSObject>

- (void)logOut;

@end

@interface SidebarViewController : UITableViewController<InterstitialPassUser>

@property (nonatomic,strong) User *loggedInUser;

@property (nonatomic,assign)id delegate;

@end
