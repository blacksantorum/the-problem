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
    // pull in data for user, store in profile, set outlets
    self.mantraLabel.text = self.profile.mantra;
    self.nameLabel.text = self.displayedUser.name;
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
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
