//
//  UserPickViewController.m
//  boxfan
//
//  Created by Chris Tibbs on 12/16/13.
//  Copyright (c) 2013 Chris Tibbs. All rights reserved.
//

#import "UserPickViewController.h"
#import "Pick.h"
#import "Fight.h"
#import "Boxer.h"
#import <Parse/Parse.h>
#import <PKRevealController/PKRevealController.h>
#import "MyProfileNavController.h"

@interface UserPickViewController ()

@property (nonatomic, strong) NSMutableArray *pickedFights; //of Fights that the user picked
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *handleAndScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *fightOfTheYearLabel;
@property (weak, nonatomic) IBOutlet UITableView *picksTable;
@property (weak, nonatomic) IBOutlet UIImageView *userPicture;

@property (strong,nonatomic) NSArray *picks;
@property (strong,nonatomic) NSArray *decisions;

@end

@implementation UserPickViewController

-(User *)loggedInUser
{
    BoxFanRevealController *bfrc= (BoxFanRevealController *)self.revealController;
    return bfrc.loggedInUser;
}

-(UIImage *)imageForURL:(NSURL *)imageURL
{
    NSData *data = [NSData dataWithContentsOfURL:imageURL];
    return [UIImage imageWithData:data];
}

-(NSDictionary *)userDictionaryFromTwitter
{
    NSURL *verify = [NSURL URLWithString:[URLS urlStringForUsersTwitterWithScreenname:self.displayedUser.handle]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:verify];
    [[PFTwitterUtils twitter] signRequest:request];
    NSURLResponse *response = nil;
    NSError *error;
    NSData *data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:&response
                                                     error:&error];
    
    NSDictionary* result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    return result;
}

-(void)viewWillAppear:(BOOL)animated
{
    User *fleshedOutUser = [[User alloc] initWithDictionary:[self userDictionaryFromTwitter]];
    self.displayedUser = fleshedOutUser;
    [self.userPicture setImage:[self imageForURL:[NSURL URLWithString:self.displayedUser.profileImageURL]]];
    self.nameLabel.text = self.displayedUser.name;
    self.handleAndScoreLabel.text = self.displayedUser.titleForGodsView;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([[self navigationController] isKindOfClass:[MyProfileNavController class]]) {
        self.displayedUser = self.loggedInUser;
    }
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

- (IBAction)userClickedShowSettings:(id)sender {
    [[self revealController] showViewController:[[self revealController] leftViewController]];
}
@end
