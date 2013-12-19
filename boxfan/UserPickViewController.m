//
//  UserPickViewController.m
//  boxfan
//
//  Created by Chris Tibbs on 12/16/13.
//  Copyright (c) 2013 Chris Tibbs. All rights reserved.
//

#import "UserPickViewController.h"
#import "User.h"
#import "Pick.h"

@interface UserPickViewController ()

@property (nonatomic, strong) User *user;
@property (nonatomic, strong) NSArray *picks; //of Picks
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *fightOfTheYearLabel;
@property (weak, nonatomic) IBOutlet UITableView *picksTable;
@property (weak, nonatomic) IBOutlet UIImageView *userPicture;

@end

@implementation UserPickViewController

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
