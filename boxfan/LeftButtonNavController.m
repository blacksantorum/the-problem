//
//  LeftButtonNavController.m
//  boxfan
//
//  Created by Chris Tibbs on 1/14/14.
//  Copyright (c) 2014 Chris Tibbs. All rights reserved.
//

#import "LeftButtonNavController.h"
#import <PKRevealController/PKRevealController.h>

@interface LeftButtonNavController ()

@end

@implementation LeftButtonNavController

- (void)showSettingsMenu
{
    [[self revealController] showViewController:[[self revealController] leftViewController]];
}

@end
