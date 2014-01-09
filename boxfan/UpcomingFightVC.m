//
//  UpcomingFightVC.m
//  boxfan
//
//  Created by Chris Tibbs on 1/8/14.
//  Copyright (c) 2014 Chris Tibbs. All rights reserved.
//

#import "UpcomingFightVC.h"

@interface UpcomingFightVC ()

@property (weak, nonatomic) IBOutlet UILabel *locationRoundsWeightLabel;
@property (weak, nonatomic) IBOutlet UILabel *fighterALabel;
@property (weak, nonatomic) IBOutlet UILabel *fighterBLabel;

@end

@implementation UpcomingFightVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
