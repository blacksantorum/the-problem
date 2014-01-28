//
//  UserProfileController.h
//  boxfan
//
//  Created by Chris Tibbs on 1/27/14.
//  Copyright (c) 2014 Chris Tibbs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserProfileController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) User *displayedUser;
@property (nonatomic,strong) User *loggedInUser;

@end
