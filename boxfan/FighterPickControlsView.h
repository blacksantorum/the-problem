//
//  FighterPickControlsView.h
//  boxfan
//
//  Created by Chris Tibbs on 1/8/14.
//  Copyright (c) 2014 Chris Tibbs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Boxer.h"

@interface FighterPickControlsView : UIView

@property (strong,nonatomic) Boxer *boxer;

#pragma mark - Outlets
@property (nonatomic,strong) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UILabel *fighterNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *listOfUsersWhoPickedFighterTextView;
@property (weak, nonatomic) IBOutlet UIButton *pickFighterButton;

- (IBAction)pickFighter:(id)sender;
- (void)setFighterLabelText;

@end
