//
//  FightDisplayVC.m
//  boxfan
//
//  Created by Chris Tibbs on 1/8/14.
//  Copyright (c) 2014 Chris Tibbs. All rights reserved.
//

#import "FightDisplayVC.h"
#import "CommentCell.h"
#import "FightInfoCell.h"
#import "ScheduleFormattedDate.h"
#import "MostJabbedCommentsDisplayVC.h"
#import "BarChartView.h"
#import "BarChartModel.h"
#import "RecentFightDisplayViewController.h"
#import "UpcomingFightViewController.h"
#import "TTTTimeIntervalFormatter.h"


@interface FightDisplayVC ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *commentTextField;

// labels
@property (weak, nonatomic) IBOutlet UILabel *boxerAFirstNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *boxerALastNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UILabel *boxerBFirstNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *boxerBLastNameLabel;

// pick, dictionary percentages
@property (strong,nonatomic) NSDictionary *boxersToPickPercentages;
@property (strong,nonatomic) NSDictionary *boxersToDecisionPercentages;

@property (strong,nonatomic) NSArray *comments;

@end

@implementation FightDisplayVC

#pragma mark - Custom cells

// fight info

- (CommentCell *)topCommentCellFor:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Comment Cell";
    
    [tableView registerClass:[CommentCell class] forCellReuseIdentifier:CellIdentifier];
    
    CommentCell *cell = (CommentCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CommentCell" owner:self options:nil];
        for (id currentObject in topLevelObjects) {
            if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                cell = (CommentCell *)currentObject;
                break;
            }
        }
    }
    
    Comment *comment = [self.comments firstObject];
    
    cell.comment = comment;
    
    [cell.jabButton setImage:[self jabButtonImageForComment:comment] forState:UIControlStateNormal];
    cell.twitterHandleButton.tintColor = [UIColor blackColor];
    [cell.twitterHandleButton setTitle:comment.author.handle forState:UIControlStateNormal];
    [cell.twitterHandleButton setTitle:comment.author.handle forState:UIControlStateHighlighted];
    
    TTTTimeIntervalFormatter *formatter = [[TTTTimeIntervalFormatter alloc] init];
    
    // formatted time interval from comment date to now
    cell.commentDateTimeLabel.text = [formatter stringForTimeIntervalFromDate:[NSDate date] toDate:comment.date];
    cell.totalJabsLabel.text = [NSString stringWithFormat:@"%d",(int)comment.jabs];
    
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(void)jabComment:(Comment *)comment
{
    NSString *url;
    if (comment.isJabbedByLoggedInUser) {
        url = [URLS urlStringForUnjabbingComment:comment];
    } else {
        url = [URLS urlStringForJabbingComment:comment];
    }
    [self.manager POST:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (UIImage *)jabButtonImageForComment:(Comment *)comment
{
    if (comment.isJabbedByLoggedInUser) {
        return [UIImage imageNamed:@"jabbed"];
    } else {
        return [UIImage imageNamed:@"notjabbed"];
    }
}

- (FightInfoCell *)fightInfoCellFor:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Fight Info Cell";
    
    [self.fightInfoTableView registerClass:[FightInfoCell class] forCellReuseIdentifier:CellIdentifier];
    
    FightInfoCell *cell = (FightInfoCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"Fight Info Cell" owner:self options:nil];
        for (id currentObject in topLevelObjects) {
            if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                cell = (FightInfoCell *)currentObject;
                break;
            }
        }
    }
    
    cell.dateLabel.text = [ScheduleFormattedDate sectionHeaderFormattedStringFromDate:self.fight.date];
    cell.locationLabel.text = self.fight.location;
    cell.roundsWeightLabel.text = [NSString stringWithFormat:@"%@ rounds at %@",self.fight.rounds,self.fight.weight];
    cell.fight = self.fight;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (PickInfoCell *)pickInfoCellFor:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Pick Info Cell";
    
    [self.fightInfoTableView registerClass:[PickInfoCell class] forCellReuseIdentifier:CellIdentifier];
    
    PickInfoCell *cell = (PickInfoCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"Pick Info Cell" owner:self options:nil];
        for (id currentObject in topLevelObjects) {
            if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                cell = (PickInfoCell *)currentObject;
                break;
            }
        }
    }
    
    if (![JSONDataNullCheck isNull:self.fight.winnerID]) {
        if (self.pick) {
            cell.makePickButton.titleLabel.text = [self pickCellButtonRepresentationForPick:self.pick];
            cell.makePickButton.enabled = NO;
        } else {
            [cell.yourPickLabel removeFromSuperview];
            [cell.makePickButton removeFromSuperview];
        }
    } else {
        if (self.pick) {
            cell.makePickButton.titleLabel.text = [self pickCellButtonRepresentationForPick:self.pick];
        }
        
        NSString *titleA = [NSString stringWithFormat:@"%@ %@%%",self.fight.boxerA.lastName,self.boxersToPickPercentages[self.fight.boxerA.boxerFullName]];
        NSString *titleB = [NSString stringWithFormat:@"%@ %@%%",self.fight.boxerB.lastName,self.boxersToPickPercentages[self.fight.boxerB.boxerFullName]];
        
        NSString *pickPercentageA = self.boxersToPickPercentages[self.fight.boxerA.boxerFullName];
        if ([pickPercentageA isEqualToString:@"0"]) {
            pickPercentageA = @"0.1";
        }
        NSString *pickPercentageB = self.boxersToPickPercentages[self.fight.boxerB.boxerFullName];
        if ([pickPercentageB isEqualToString:@"0"]) {
            pickPercentageB = @"0.1";
        }
        
        NSArray *array = [cell.communityPicksBarChart createChartDataWithTitles:[NSArray arrayWithObjects:titleA,titleB, nil]
                                                      values:[NSArray arrayWithObjects:pickPercentageA,pickPercentageB, nil]
                                                      colors:[NSArray arrayWithObjects:@"FF0000", @"0000FF", nil]
                                                 labelColors:[NSArray arrayWithObjects:@"000000", @"000000", nil]];
        
        if (array && [pickPercentageA length] && [pickPercentageB length]) {
            [cell.communityPicksBarChart setDataWithArray:array
                                                 showAxis:DisplayBothAxes
                                                withColor:[UIColor whiteColor]
                                                 withFont:[UIFont systemFontOfSize:11]
                                  shouldPlotVerticalLines:NO];
        }
    }
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (DecisionInfoCell *)decisionInfoCellFor:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Decision Info Cell";
    
    [self.fightInfoTableView registerClass:[DecisionInfoCell class] forCellReuseIdentifier:CellIdentifier];
    
    DecisionInfoCell *cell = (DecisionInfoCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"Decision Info Cell" owner:self options:nil];
        for (id currentObject in topLevelObjects) {
            if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                cell = (DecisionInfoCell *)currentObject;
                break;
            }
        }
    }
    
    if (self.decision) {
        [cell.makeDecisionButton setTitle:[self decisionCellButtonRepresentationForDecision:self.decision] forState:UIControlStateNormal];
        [cell.makeDecisionButton setTitle:[self decisionCellButtonRepresentationForDecision:self.decision] forState:UIControlStateHighlighted];
    }
    
    NSString *titleA = [NSString stringWithFormat:@"%@ %@%%",self.fight.boxerA.lastName,self.boxersToDecisionPercentages[self.fight.boxerA.boxerFullName]];
    NSString *titleB = [NSString stringWithFormat:@"%@ %@%%",self.fight.boxerB.lastName,self.boxersToDecisionPercentages[self.fight.boxerB.boxerFullName]];
    
    NSString *decisionPercentageA = self.boxersToDecisionPercentages[self.fight.boxerA.boxerFullName];
    if ([decisionPercentageA isEqualToString:@"0"]) {
        decisionPercentageA = @"0.1";
    }
    NSString *decisionPercentageB = self.boxersToPickPercentages[self.fight.boxerB.boxerFullName];
    if ([decisionPercentageB isEqualToString:@"0"]) {
        decisionPercentageB = @"0.1";
    }
    
    UIColor *red = [UIColor redColor];
    UIColor *blue = [UIColor blueColor];
    UIColor *black = [UIColor blackColor];
    
    NSArray *array = [cell.communityDecisionBarChart createChartDataWithTitles:[NSArray arrayWithObjects:titleA,titleB, nil]
                                                                     values:[NSArray arrayWithObjects:decisionPercentageA,decisionPercentageB, nil]
                                                                     colors:[NSArray arrayWithObjects:red, blue, nil]
                                                                labelColors:[NSArray arrayWithObjects:black, black, nil]];
    
    if (array) {
        [cell.communityDecisionBarChart setDataWithArray:array
                                             showAxis:DisplayOnlyXAxis
                                            withColor:[UIColor darkGrayColor]
                                             withFont:[UIFont systemFontOfSize:11]
                              shouldPlotVerticalLines:NO];
    }
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(NSString *)pickCellButtonRepresentationForPick:(Pick *)pick
{
    return [NSString stringWithFormat:@"%@ %@",pick.winner.lastName,pick.byStoppage ? @"by KO" : @"by dec"];
}

-(NSString *)decisionCellButtonRepresentationForDecision:(Decision *)decision
{
    return [NSString stringWithFormat:@"%@ won",decision.winner.lastName];
}

-(AFHTTPRequestOperationManager *)manager
{
    return [AFHTTPRequestOperationManager manager];
}

-(User *)loggedInUser
{
    BoxFanRevealController *bfrc= (BoxFanRevealController *)self.revealController;
    return bfrc.loggedInUser;
}

-(void)refresh
{
    NSURL *url = [NSURL URLWithString:[URLS urlForUsersCurrentPickForFight:self.fight]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            NSLog(@"Connection error: %@", connectionError);
        } else {
            NSError *error = nil;
            id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            if (error) {
                NSLog(@"JSON parsing error: %@", error);
            } else {
                NSLog(@"Object: %@",object);
                self.JSONdictionary = (NSDictionary *)object;
                [self configureDataSource];
            }
        }
    }];
}

-(void)configureDataSource
{
    NSDictionary *pickDictionary = self.JSONdictionary;
    self.pick = [[Pick alloc] initWithFightViewDictionary:pickDictionary];
    
    NSDictionary *decisionDictionary = [self.JSONdictionary valueForKeyPath:@"fight.decision"];
    
    if (![JSONDataNullCheck isNull:decisionDictionary]) {
        self.decision = [[Decision alloc] initWithRecentFightDisplayDictionary:decisionDictionary];
    }
    
    NSMutableDictionary *boxersToPicksPercentages = [[NSMutableDictionary alloc] init];
    for (NSDictionary *boxerDict in [self.JSONdictionary valueForKeyPath:@"fight.boxers"]) {
        NSString *boxerName = [NSString stringWithFormat:@"%@ %@",[boxerDict valueForKeyPath:@"boxer.first_name"],[boxerDict valueForKeyPath:@"boxer.last_name"]];
        NSString *pickPercentage = [boxerDict valueForKeyPath:@"boxer.percent_pick"];
        [boxersToPicksPercentages addEntriesFromDictionary:@{boxerName:pickPercentage.description}];
    }
    self.boxersToPickPercentages = boxersToPicksPercentages;
    
    NSMutableDictionary *boxersToDecisionPercentages = [[NSMutableDictionary alloc] init];
    for (NSDictionary *boxerDict in [self.JSONdictionary valueForKeyPath:@"fight.boxers"]) {
        NSString *boxerName = [NSString stringWithFormat:@"%@ %@",[boxerDict valueForKeyPath:@"boxer.first_name"],[boxerDict valueForKeyPath:@"boxer.last_name"]];
        NSString *decisionPercentage = [boxerDict valueForKeyPath:@"boxer.percent_decision"];
        [boxersToDecisionPercentages addEntriesFromDictionary:@{boxerName:decisionPercentage.description}];
    }
    self.boxersToDecisionPercentages = boxersToDecisionPercentages;
    
    NSMutableArray *commentsArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary *commentDict in [self.JSONdictionary valueForKeyPath:@"fight.comments"]) {
        Comment *c = [[Comment alloc] initWithDictionary:[commentDict objectForKey:@"comment"]];
        [commentsArray addObject:c];
    }
    
    self.comments = commentsArray;
    
    /*
    self.comments = [commentsArray sortedArrayUsingComparator: ^(id a, id b) {
        NSInteger j1 = [(Comment *)a jabs];
        NSInteger j2 = [(Comment *)b jabs];
        return j1 > j2;
    }];
    */
     
    [self.fightInfoTableView reloadData];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setLabels];
    [self refresh];
    NSLog(@"%@",self.loggedInUser);
    
    self.navigationController.toolbarHidden = YES;
    
    UITextView * textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 100, 32)];
    textView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    UIBarButtonItem * barItem = [[UIBarButtonItem alloc] initWithCustomView:textView];
    [textView sizeToFit];
    
    self.navigationController.toolbar.items = [NSArray arrayWithObject:barItem];
}

- (void)setLabels
{
    self.boxerAFirstNameLabel.text = self.fight.boxerA.firstName;
    self.boxerALastNameLabel.text = self.fight.boxerA.lastName;
    self.boxerBFirstNameLabel.text = self.fight.boxerB.firstName;
    self.boxerBLastNameLabel.text = self.fight.boxerB.lastName;
    
    if (![JSONDataNullCheck isNull:self.fight.winnerID]) {
        if (self.fight.stoppage) {
            self.resultLabel.text = @"KO";
        } else {
            self.resultLabel.text = @"def.";
        }
    } else {
        self.resultLabel.text = @"-";
    }
}

-(void)postUserActivityDictionary:(NSDictionary *)dictionary toURLString:(NSString *)url
{
    [self.manager POST:url parameters:dictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        [self refresh];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return @"";
    }
    else if (section == 1)
    {
        return @"Fight Info";
    }
    else if (section == 2)
    {
        return @"Predictions";
    }
    else
    {
        return @"Decisions";
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return [self topCommentCellFor:tableView forIndexPath:indexPath];
    }
    else if (indexPath.section == 1) {
        FightInfoCell *cell = [self fightInfoCellFor:tableView forIndexPath:indexPath];
        cell.delegate = self;
        
        if ([self isKindOfClass:[UpcomingFightViewController class]]) {
            [cell.FOYButton removeFromSuperview];
        }
        if ([self isKindOfClass:[RecentFightDisplayViewController class]]) {
            if ([self.fight.fightID.description isEqualToString:self.loggedInUser.foy.fightID.description]) {
                cell.FOYButton.titleLabel.text = @"This is your FOY";
                cell.FOYButton.enabled = NO;
            }
        }
        return cell;
    }
    else if (indexPath.section == 2) {
        return [self pickInfoCellFor:tableView forIndexPath:indexPath];
    }
    else {
        return [self decisionInfoCellFor:tableView forIndexPath:indexPath];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showComments"]) {
        MostJabbedCommentsDisplayVC *controller = (MostJabbedCommentsDisplayVC *)segue.destinationViewController;
        controller.title = self.fight.titleForScheduleView;
        controller.fight = self.fight;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 113.0;
    } else if (indexPath.section == 1) {
        return 66.0;
    } else {
        return 250.0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath == [NSIndexPath indexPathForRow:0 inSection:0]) {
        [self performSegueWithIdentifier:@"showComments" sender:[tableView cellForRowAtIndexPath:indexPath]];
    }
}


@end
