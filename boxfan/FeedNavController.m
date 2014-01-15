//
//  FeedNavController.m
//  boxfan
//
//  Created by Chris Tibbs on 1/14/14.
//  Copyright (c) 2014 Chris Tibbs. All rights reserved.
//

#import "FeedNavController.h"

@interface FeedNavController ()

@end

@implementation FeedNavController

-(void)viewDidLoad
{
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Switch"
                                                                    style:UIBarButtonItemStyleDone target:nil action:nil];
    self.navigationItem.leftBarButtonItem = leftButton;
}

@end
