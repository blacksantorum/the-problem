//
//  TBACommentsMultipleVC.h
//  boxfan
//
//  Created by Chris Tibbs on 1/25/14.
//  Copyright (c) 2014 Chris Tibbs. All rights reserved.
//

#import "RMMultipleViewsController.h"
#import "Fight.h"

@interface TBACommentsMultipleVC : RMMultipleViewsController

@property (nonatomic,strong) Fight *fight;
@property (nonatomic,strong) User *loggedInUser;

@end
