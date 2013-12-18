//
//  FightDetailViewController.m
//  boxfan
//
//  Created by Chris Tibbs on 12/16/13.
//  Copyright (c) 2013 Chris Tibbs. All rights reserved.
//

#import "FightDetailViewController.h"
#import "Fight.h"
#import "Boxer.h"

@interface FightDetailViewController ()

# pragma mark - Pick Controls/Display

@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *weightAndRoundsLabel;
// A-side controls
@property (weak, nonatomic) IBOutlet UILabel *fighterALabel;
- (IBAction)pickFighterAByStoppage:(UIButton *)sender;
- (IBAction)pickFighterAByDecision:(UIButton *)sender;

// B-side controls
@property (weak, nonatomic) IBOutlet UILabel *fighterBLabel;
- (IBAction)pickFighterBByStoppage:(UIButton *)sender;
- (IBAction)pickFighterBByDecision:(UIButton *)sender;

# pragma mark - Community Picks Collections

// Top users who picked A-side
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *topUsersWhoPickedFighterAByStoppage;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *topUsersWhoPickedFighterAByDecision;

// Top users who picked B-side
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *topUsersWhoPickedFighterBByStoppage;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *topUsersWhoPickedFighterBByDecision;

@end

@implementation FightDetailViewController

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
    // set title, fight descriptors
    [self setTitle:[self.fight titleForScheduleView]];
    [self.locationLabel setText:self.fight.location];
    [self.weightAndRoundsLabel setText:[NSString stringWithFormat:@"%@ rounds at %@lbs",self.fight.rounds,self.fight.weight]];
    
	// set fighter labels
    Boxer *a = [self.fight.boxers objectAtIndex:0];
    [self.fighterALabel setText:[a boxerFullName]];
    
    Boxer *b = [self.fight.boxers objectAtIndex:1];
    [self.fighterBLabel setText:[b boxerFullName]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pickFighterAByStoppage:(UIButton *)sender {
}

- (IBAction)pickFighterAByDecision:(UIButton *)sender {
}
- (IBAction)pickFighterBByStoppage:(UIButton *)sender {
}

- (IBAction)pickFighterBByDecision:(UIButton *)sender {
}
@end
