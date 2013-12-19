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
#import "Fight.h"
#import "Boxer.h"

@interface UserPickViewController ()

@property (nonatomic, strong) User *user;
@property (nonatomic, strong) NSMutableArray *pickedFights; //of Fights that the user picked
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *fightOfTheYearLabel;
@property (weak, nonatomic) IBOutlet UITableView *picksTable;
@property (weak, nonatomic) IBOutlet UIImageView *userPicture;

@end

@implementation UserPickViewController

-(NSMutableArray *)pickedfights
{
    if(!_pickedFights) {
        _pickedFights = [[NSMutableArray alloc] init];
    }
    return _pickedFights;
}


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
    self.picksTable.delegate = self;
    self.picksTable.dataSource = self;
    [self.picksTable reloadData];
	// Do any additional setup after loading the view.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.pickedFights count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Pick Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    Fight *f = self.pickedFights[indexPath.row];
    cell.textLabel.text = f.titleForScheduleView;
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
