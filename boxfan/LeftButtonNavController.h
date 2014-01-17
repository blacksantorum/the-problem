//
//  LeftButtonNavController.h
//  boxfan
//
//  Created by Chris Tibbs on 1/14/14.
//  Copyright (c) 2014 Chris Tibbs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "BoxFanRevealController.h"

@interface LeftButtonNavController : UINavigationController

@property (nonatomic,strong) User *loggedInUser;

- (void)showSettingsMenu;

@end
