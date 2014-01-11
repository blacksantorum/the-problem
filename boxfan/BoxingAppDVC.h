//
//  BoxingAppDVC.h
//  boxfan
//
//  Created by Chris Tibbs on 1/8/14.
//  Copyright (c) 2014 Chris Tibbs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface BoxingAppDVC : UITableViewController

@property (strong,nonatomic)  User *user;
@property (strong,atomic) NSURL *urlForRequest;
@property (strong,atomic) NSArray *JSONarray;

-(void)configureDataSource;

@end
