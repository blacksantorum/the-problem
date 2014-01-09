//
//  UpcomingFightVC.m
//  boxfan
//
//  Created by Chris Tibbs on 1/8/14.
//  Copyright (c) 2014 Chris Tibbs. All rights reserved.
//

#import "UpcomingFightVC.h"
#import "FighterPickControlsView.h"
#import "PickFightView.h"

@interface UpcomingFightVC ()

@property (weak, nonatomic) IBOutlet UILabel *locationRoundsWeightLabel;
@property (weak, nonatomic) IBOutlet FighterPickControlsView *fighterAPickControl;

@property (weak, nonatomic) IBOutlet FighterPickControlsView *fighterBPickControl;

@end

@implementation UpcomingFightVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)setUpView
{
    self.fighterAPickControl.boxer = [self.fight.boxers firstObject];
    self.fighterBPickControl.boxer = [self.fight.boxers lastObject];
    self.locationRoundsWeightLabel.text = [NSString stringWithFormat:@"%@: %@ rounds at %@",self.fight.location,self.fight.rounds,self.fight.weight];
    self.fighterAPickControl.delegate = self;
    self.fighterBPickControl.delegate = self;
}

-(void)fighterChosen:(Boxer *)boxer
{
    PickFightView *pickFightView = [[PickFightView alloc] initWithFrame:CGRectMake(0, 500, 320, 90)];
    pickFightView.boxer = boxer;
    [self.view addSubview:pickFightView];
}

@end
