//
//  MyProfileNavController.m
//  boxfan
//
//  Created by Chris Tibbs on 1/16/14.
//  Copyright (c) 2014 Chris Tibbs. All rights reserved.
//

#import "MyProfileNavController.h"

@interface MyProfileNavController ()

@end

@implementation MyProfileNavController

-(User *)displayedUser
{
    return self.loggedInUser;
}

@end
