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
#import "Decision.h"

@interface UserPickViewController ()

@property (nonatomic, strong) NSMutableArray *pickedFights; //of Fights that the user picked
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *handleAndScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *fightOfTheYearLabel;
@property (weak, nonatomic) IBOutlet UITableView *picksTable;
@property (weak, nonatomic) IBOutlet UIImageView *userPicture;
@property (weak, nonatomic) IBOutlet UISegmentedControl *picksOrDecisionsControl;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;


// show picks if this isn't turned on
@property BOOL shouldShowDecisions;
@property (strong,nonatomic) NSDictionary *userActions;
@property (strong,nonatomic) NSArray *picks;
@property (strong,nonatomic) NSArray *decisions;

@end

@implementation UserPickViewController

-(void)refresh
{
    [self.activityIndicator startAnimating];
    NSURLRequest *request = [NSURLRequest requestWithURL:[URLS urlForPicksOfUser:self.displayedUser]];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            NSLog(@"Connection error: %@", connectionError);
        } else {
            NSError *error = nil;
            id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            if (error) {
                NSLog(@"JSON parsing error: %@", error);
            } else {
                self.userActions = (NSDictionary *)object;
                NSLog(@"%@",self.userActions);
                [self configureDataSource];
                [self.picksTable reloadData];
                [self.activityIndicator stopAnimating];
                self.activityIndicator.hidden = YES;
                ;
            }
        }
    }];
}

-(void)configureDataSource
{
    NSArray *decisionsArrayJSON = [self.userActions valueForKeyPath:@"user.decisions"];
    
    NSMutableArray *decisionsArray = [[NSMutableArray alloc] init];
    for (NSDictionary *decisionDictionary in decisionsArrayJSON) {
        Decision *d = [[Decision alloc] initWithDisplayedUserView:decisionDictionary];
        [decisionsArray addObject:d];
    }
    self.decisions = decisionsArray;
    
    NSArray *picksArrayJSON = [self.userActions valueForKeyPath:@"user.picks"];
    
    NSMutableArray *picksArray = [[NSMutableArray alloc] init];
    for (NSDictionary *pickDictionary in picksArrayJSON) {
        Pick *p = [[Pick alloc] initWithDisplayedUserView:pickDictionary];
        [picksArray addObject:p];
    }
    self.picks = picksArray;
}

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([[self navigationController] isKindOfClass:[MyProfileNavController class]]) {
        self.displayedUser = self.loggedInUser;
    }
    self.picksTable.delegate = self;
    self.picksTable.dataSource = self;
    [self refresh];
    [self.picksTable reloadData];
	// Do any additional setup after loading the view.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.shouldShowDecisions) {
        return [self.decisions count];
    } else {
        return [self.picks count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"User Activity Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSInteger row = indexPath.row;
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (self.shouldShowDecisions) {
        Decision *d = self.decisions[row];
        cell.textLabel.text = d.usersDisplayViewRepresentation;
    } else {
        Pick *p = self.picks[row];
        cell.textLabel.text = p.usersDisplayViewRepresentation;
    }
    
    return cell;
}

- (IBAction)userClickedShowSettings:(id)sender {
    [[self revealController] showViewController:[[self revealController] leftViewController]];
}

- (IBAction)changedPicksOrDecisionsControl:(UISegmentedControl *)sender {
    NSInteger selectedSegment = sender.selectedSegmentIndex;
    
    if (selectedSegment == 0) {
        self.shouldShowDecisions = NO;
    }
    if (selectedSegment == 1) {
        self.shouldShowDecisions = YES;
    }
    
    [self.picksTable reloadData];
}



@end
