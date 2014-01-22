//
//  FightDisplayVC.m
//  boxfan
//
//  Created by Chris Tibbs on 1/8/14.
//  Copyright (c) 2014 Chris Tibbs. All rights reserved.
//

#import "FightDisplayVC.h"

@interface FightDisplayVC ()

- (void)setUpView;

// labels
@property (weak, nonatomic) IBOutlet UILabel *boxerAFirstNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *boxerALastNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UILabel *boxerBFirstNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *boxerBLastNameLabel;


@end

@implementation FightDisplayVC

-(Boxer *)boxerA
{
    if (!_boxerA) {
        _boxerA = [self.fight.boxers firstObject];
    }
    return _boxerA;
}

-(Boxer *)boxerB
{
    if (!_boxerB) {
        _boxerB = [self.fight.boxers lastObject];
    }
    return _boxerB;
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
    //
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setLabels];
	[self setUpView];
    [self refresh];
}

- (void)setUpView
{
    //
}

- (void)setLabels
{
    self.boxerAFirstNameLabel.text = self.boxerA.firstName;
    self.boxerALastNameLabel.text = self.boxerA.lastName;
    self.boxerBFirstNameLabel.text = self.boxerB.firstName;
    self.boxerBLastNameLabel.text = self.boxerB.lastName;
    
    if (self.fight.winnerID) {
        if (self.fight.stoppage) {
            self.resultLabel.text = @"KO";
        } else {
            self.resultLabel.text = @"def.";
        }
    } else {
        self.resultLabel.text = @"-";
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

@end
