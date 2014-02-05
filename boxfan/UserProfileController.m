//
//  UserProfileController.m
//  boxfan
//
//  Created by Chris Tibbs on 1/27/14.
//  Copyright (c) 2014 Chris Tibbs. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "UserProfileController.h"
#import "BoxFanRevealController.h"
#import "Profile.h"
#import "FOYCell.h"
#import "ProfileCell.h"
#import "UserHistoryTableVC.h"
#import "boxfanAppDelegate.h"
#import "MyProfileNavController.h"

@interface UserProfileController ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mantraLabel;


@property (weak, nonatomic) IBOutlet UITableView *profileTableView;

@property (strong,nonatomic) Profile *profile;

@property (strong,nonatomic) UIStoryboard *storyboard;
@property (strong,nonatomic) AFHTTPRequestOperationManager *manager;

- (IBAction)userClickedShowSettings:(id)sender;

@end

@implementation UserProfileController

- (IBAction)userClickedShowSettings:(id)sender
{
    [self showSettingsMenu];
}

- (void)showSettingsMenu
{
    [[self revealController] showViewController:[[self revealController] leftViewController]];
}

- (User *)displayedUser
{
    if ([self.navigationController isKindOfClass:[MyProfileNavController class]]) {
        _displayedUser = self.loggedInUser;
        self.title = self.loggedInUser.handle;
    }
    return _displayedUser;
}

-(UIImage *)imageForURL:(NSURL *)imageURL
{
    NSData *data = [NSData dataWithContentsOfURL:imageURL];
    return [UIImage imageWithData:data];
}

- (AFHTTPRequestOperationManager *)manager
{
    return [AFHTTPRequestOperationManager manager];
}

-(UIStoryboard *)storyboard
{
    return [UIStoryboard storyboardWithName:@"Main" bundle:nil];
}

-(User *)loggedInUser
{
    BoxFanRevealController *bfrc= (BoxFanRevealController *)self.revealController;
    return bfrc.loggedInUser;
}

- (NSString *)boxerNameDisplay:(Boxer *)boxer
{
    return [NSString stringWithFormat:@"%@. %@",[boxer.firstName substringToIndex:1] ,boxer.lastName];
}

- (FOYCell *)FOYCellForTableView:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FOY Cell";
    
    [self.profileTableView registerClass:[FOYCell class] forCellReuseIdentifier:CellIdentifier];
    
    FOYCell *cell = (FOYCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"FOY Cell" owner:self options:nil];
        for (id currentObject in topLevelObjects) {
            if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                cell = (FOYCell *)currentObject;
                break;
            }
        }
    }
    
    Fight *FOY = self.profile.FOY;
    
    cell.fighterALabel.text = [self boxerNameDisplay:FOY.boxerA];
    cell.fighterBLabel.text = [self boxerNameDisplay:FOY.boxerB];
    cell.resultLabel.text = [NSString stringWithFormat:@"%@", FOY.stoppage ? @"KO" : @"def"];
    
    return cell;
}

- (ProfileCell *)ProfileCellForTableView:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Profile Cell";
    
    [self.profileTableView registerClass:[ProfileCell class] forCellReuseIdentifier:CellIdentifier];
    
    ProfileCell *cell = (ProfileCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"Profile Cell" owner:self options:nil];
        for (id currentObject in topLevelObjects) {
            if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                cell = (ProfileCell *)currentObject;
                break;
            }
        }
    }
    
    cell.firstFightLabel.text = self.profile.firstFight;
    cell.favoriteFighterLabel.text = self.profile.favoriteBoxer;
    cell.favoriteFightLabel.text = self.profile.favoriteFight;
    
    return cell;
}

- (BOOL)hasFightOfTheYear
{
    NSLog(@"%@",self.profile.FOY);
    if (self.profile.FOY) {
        return YES;
    } else {
        return NO;
    }
}

- (void)refresh
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[URLS urlForPicksOfUser:self.displayedUser]];
    
    NSLog(@"%@",request);
    
    [(boxfanAppDelegate *)[[UIApplication sharedApplication] delegate] setNetworkActivityIndicatorVisible:YES];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            NSLog(@"Connection error: %@", connectionError);
        } else {
            NSError *error = nil;
            id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            if (error) {
                NSLog(@"JSON parsing error: %@", error);
            } else {
                NSLog(@"%@",object);
                NSDictionary *userDictionary = (NSDictionary *)object;
                self.profile = [[Profile alloc] initWithDictionary:[userDictionary objectForKey:@"user"]];
                self.mantraLabel.text = self.profile.mantra;
                [self.profileTableView reloadData];
                
            }
        }
        [(boxfanAppDelegate *)[[UIApplication sharedApplication] delegate] setNetworkActivityIndicatorVisible:NO];
    }];
    self.nameLabel.text = self.displayedUser.name;
    [self.profileImageView setImage:[self imageForURL:[NSURL URLWithString:self.displayedUser.profileImageURL]]];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // if ([self.displayedUser.handle caseInsensitiveCompare:self.loggedInUser.handle] == NSOrderedSame) {
     //   UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(presentEditProfileView)];
     //   self.navigationItem.rightBarButtonItem = rightButton;
    // }
	[self refresh];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:@"connectionRestored" object:nil];
}

- (void)presentEditProfileView
{
    UpdateProfileViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"updateProfile"];
    vc.mantraTextField.text = self.profile.mantra;
    vc.firstFightTextField.text = self.profile.firstFight;
    vc.favoriteBoxerTextField.text = self.profile.favoriteBoxer;
    vc.favoriteFightTextField.text = self.profile.favoriteFight;
    vc.delegate = self;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)updateProfile:(NSDictionary *)dictionary
{
    [(boxfanAppDelegate *)[[UIApplication sharedApplication] delegate] setNetworkActivityIndicatorVisible:YES];
    [self.manager PUT:[URLS urlStringForUpdatingProfileForUser:self.loggedInUser] parameters:dictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        [self refresh];
        [(boxfanAppDelegate *)[[UIApplication sharedApplication] delegate] setNetworkActivityIndicatorVisible:NO];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [(boxfanAppDelegate *)[[UIApplication sharedApplication] delegate] setNetworkActivityIndicatorVisible:NO];
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([self hasFightOfTheYear]) {
        return 2;
    } else {
        return 1;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showHistory"]) {
        UserHistoryTableVC *controller = (UserHistoryTableVC *)segue.destinationViewController;
        controller.title = self.displayedUser.handle;
        controller.displayedUser = self.displayedUser;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([self hasFightOfTheYear]) {
        if (section == 0) {
            return @"Fight of the Year";
        } else {
            return @"Profile";
        }
    } else {
        return @"Profile";
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self hasFightOfTheYear]) {
        if (indexPath.section == 0) {
            return 82.0;
        } else {
            return 225.0;
        }
    } else {
        return 225.0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self hasFightOfTheYear]) {
        if (indexPath.section == 0) {
            return [self FOYCellForTableView:tableView forIndexPath:indexPath];
        } else {
            return [self ProfileCellForTableView:tableView forIndexPath:indexPath];
        }
    } else {
        return [self ProfileCellForTableView:tableView forIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.displayedUser.handle caseInsensitiveCompare:self.loggedInUser.handle] == NSOrderedSame) {
        if ([self hasFightOfTheYear]) {
            if (indexPath.section == 1) {
                [self presentEditProfileView];
            }
        } else {
            [self presentEditProfileView];
        }
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"connectionRestored" object:nil];
}

@end
