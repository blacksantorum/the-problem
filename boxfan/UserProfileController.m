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
#import "RecordCell.h"

@interface UserProfileController () {
    NSDictionary *professionalRecord;
    UIActivityIndicatorView *spinner;
}

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UITextView *mantraTextView;


@property (weak, nonatomic) IBOutlet UITableView *profileTableView;

@property (strong,nonatomic) Profile *profile;

@property (strong,nonatomic) UIStoryboard *storyboard;
@property (strong,nonatomic) AFHTTPRequestOperationManager *manager;

- (IBAction)userClickedShowSettings:(id)sender;

@end

@implementation UserProfileController

- (void)addActivityViewIndicator
{
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:spinner];
    spinner.center = self.view.center;
}

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

- (RecordCell *)RecordCellForTableView:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Record Cell";
    
    [self.profileTableView registerClass:[RecordCell class] forCellReuseIdentifier:CellIdentifier];
    
    RecordCell *cell = (RecordCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"RecordCell" owner:self options:nil];
        for (id currentObject in topLevelObjects) {
            if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                cell = (RecordCell *)currentObject;
                break;
            }
        }
    }
    
    if ([professionalRecord objectForKey:@"correct"]) {
        cell.correctPicksLabel.text = [NSString stringWithFormat:@"%@ correct picks",[[professionalRecord objectForKey:@"correct"] stringValue]];
        cell.incorrectPicksLabel.text = [NSString stringWithFormat:@"%@ incorrect picks",[[professionalRecord objectForKey:@"incorrect"] stringValue]];
    }
    
    return cell;
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
 
    if (self.profile.FOY) {
        return YES;
    } else {
        return NO;
    }
}

- (void)refresh
{
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[URLS urlForPicksOfUser:self.displayedUser]];
    [spinner startAnimating];
    [(boxfanAppDelegate *)[[UIApplication sharedApplication] delegate] setNetworkActivityIndicatorVisible:YES];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
          
        } else {
            NSError *error = nil;
            id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            if (error) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry. Can't connect."
                                                                message:@"Please check your data connection"
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            } else {
              
                NSDictionary *userDictionary = (NSDictionary *)object;
                self.profile = [[Profile alloc] initWithDictionary:[userDictionary objectForKey:@"user"]];
                
                NSInteger numberOfPicks = [[userDictionary valueForKeyPath:@"user.fights_picked"] integerValue];
                NSInteger correctPicks = [[userDictionary valueForKeyPath:@"user.correct_picks"] integerValue];
                
                professionalRecord = @{@"correct" : [NSNumber numberWithInteger:correctPicks], @"incorrect": [NSNumber numberWithInteger:numberOfPicks - correctPicks]};
                
                [self.mantraTextView setText:nil];
                [self.mantraTextView setText:self.profile.mantra];
                [self.profileTableView reloadData];
                
            }
        }
        [(boxfanAppDelegate *)[[UIApplication sharedApplication] delegate] setNetworkActivityIndicatorVisible:NO];
        [spinner stopAnimating];
    }];
    self.nameLabel.text = self.displayedUser.name;
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        UIImage *profileImage = [self imageForURL:[NSURL URLWithString:self.displayedUser.profileImageURL]];
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self.profileImageView setImage:profileImage];
        });
    });
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addActivityViewIndicator];
	[self refresh];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:@"connectionRestored" object:nil];
}

- (void)presentEditProfileView
{
    UpdateProfileViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"updateProfile"];
    vc.mantra = self.profile.mantra;
    vc.firstFight = self.profile.firstFight;
    vc.favoriteBoxer = self.profile.favoriteBoxer;
    vc.favoriteFight = self.profile.favoriteFight;
    vc.delegate = self;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)updateProfile:(NSDictionary *)dictionary
{
    [(boxfanAppDelegate *)[[UIApplication sharedApplication] delegate] setNetworkActivityIndicatorVisible:YES];
    [self.manager PUT:[URLS urlStringForUpdatingProfileForUser:self.loggedInUser] parameters:dictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
   
        [self refresh];
        [(boxfanAppDelegate *)[[UIApplication sharedApplication] delegate] setNetworkActivityIndicatorVisible:NO];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     
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
        return 3;
    } else {
        return 2;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showHistory"]) {
        UserHistoryTableVC *controller = (UserHistoryTableVC *)segue.destinationViewController;
        
        UIBarButtonItem *newBackButton =
        [[UIBarButtonItem alloc] initWithTitle:@"Profile"
                                         style:UIBarButtonItemStyleBordered
                                        target:nil
                                        action:nil];
        [[self navigationItem] setBackBarButtonItem:newBackButton];
        
        controller.title = self.displayedUser.handle;
        controller.displayedUser = self.displayedUser;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionTitle;
    
    if (section == 0) {
        sectionTitle = @"Professional Record";
    } else {
        if ([self hasFightOfTheYear]) {
            if (section == 1) {
                sectionTitle = @"Fight of the Year";
            } else {
                sectionTitle = @"Profile";
            }
        } else {
            sectionTitle = @"Profile";
        }
    }
    return sectionTitle;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat sectionHeight;
    
    if (indexPath.section == 0) {
        sectionHeight = 93.0;
    } else {
        if ([self hasFightOfTheYear]) {
            if (indexPath.section == 1) {
                sectionHeight = 90.0;
            } else {
                sectionHeight = 225.0;
            }
        } else {
            sectionHeight = 225.0;
        }
    }
    return sectionHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if (indexPath.section == 0) {
        cell = [self RecordCellForTableView:tableView forIndexPath:indexPath];
    } else {
        if ([self hasFightOfTheYear]) {
            if (indexPath.section == 1) {
                cell = [self FOYCellForTableView:tableView forIndexPath:indexPath];
            } else {
                cell = [self ProfileCellForTableView:tableView forIndexPath:indexPath];
            }
        } else {
            cell = [self ProfileCellForTableView:tableView forIndexPath:indexPath];
        }
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.displayedUser.handle caseInsensitiveCompare:self.loggedInUser.handle] == NSOrderedSame) {
        if ([self hasFightOfTheYear]) {
            if (indexPath.section == 2) {
                [self presentEditProfileView];
            }
        } else if (indexPath.section == 1) {
            [self presentEditProfileView];
        }
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"connectionRestored" object:nil];
}

@end
