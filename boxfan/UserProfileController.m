//
//  UserProfileController.m
//  boxfan
//
//  Created by Chris Tibbs on 1/27/14.
//  Copyright (c) 2014 Chris Tibbs. All rights reserved.
//

#import "UserProfileController.h"
#import "BoxFanRevealController.h"
#import "Profile.h"
#import "FOYCell.h"
#import "ProfileCell.h"

@interface UserProfileController ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mantraLabel;


@property (weak, nonatomic) IBOutlet UITableView *profileTableView;

@property (strong,nonatomic) Profile *profile;

@end

@implementation UserProfileController

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
    return (self.profile.FOY);
}

- (void)refresh
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[URLS urlForPicksOfUser:self.displayedUser]];
    
    NSLog(@"%@",request);
    
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
            }
        }
    }];
    self.nameLabel.text = self.displayedUser.name;
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"%@ %@", self.displayedUser.handle, self.loggedInUser.handle);
    if ([self.displayedUser.handle caseInsensitiveCompare:self.loggedInUser.handle] == NSOrderedSame) {
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit"
                                                                        style:UIBarButtonItemStyleDone target:self action:@selector(presentEditProfileView)];
        self.navigationItem.rightBarButtonItem = rightButton;
    }
	[self refresh];
}

- (void)presentEditProfileView
{
    
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

@end
