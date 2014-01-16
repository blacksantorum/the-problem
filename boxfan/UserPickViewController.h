//
//  UserPickViewController.h
//  boxfan
//
//  Created by Chris Tibbs on 12/16/13.
//  Copyright (c) 2013 Chris Tibbs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface UserPickViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong) User *user;
- (IBAction)userClickedShowSettings:(id)sender;

@end
