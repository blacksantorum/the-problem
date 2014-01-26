//
//  TBACommentsMultipleVC.m
//  boxfan
//
//  Created by Chris Tibbs on 1/25/14.
//  Copyright (c) 2014 Chris Tibbs. All rights reserved.
//

#import "TBACommentsMultipleVC.h"

@interface TBACommentsMultipleVC ()

@end

@implementation TBACommentsMultipleVC

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    NSMutableArray *initialViewController = [NSMutableArray array];
    [initialViewController addObject:[self.storyboard instantiateViewControllerWithIdentifier:@"FirstView"]];
    [initialViewController addObject:[self.storyboard instantiateViewControllerWithIdentifier:@"SecondView"]];
    
    self.viewController = initialViewController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

@end
