//
//  LeftButtonNavController.m
//  boxfan
//
//  Created by Chris Tibbs on 1/14/14.
//  Copyright (c) 2014 Chris Tibbs. All rights reserved.
//

#import "LeftButtonNavController.h"

@interface LeftButtonNavController ()

@end

@implementation LeftButtonNavController

- (void)viewDidLoad
{
    [super viewDidLoad];
	UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Switch"
                                                                   style:UIBarButtonItemStyleDone target:nil action:nil];
    self.navigationItem.leftBarButtonItem = leftButton;
}

@end
