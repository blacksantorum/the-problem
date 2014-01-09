//
//  FighterPickControlsView.m
//  boxfan
//
//  Created by Chris Tibbs on 1/8/14.
//  Copyright (c) 2014 Chris Tibbs. All rights reserved.
//

#import "FighterPickControlsView.h"

@implementation FighterPickControlsView

@synthesize delegate;

-(void)setBoxer:(Boxer *)boxer
{
    self.fighterNameLabel.text = boxer.boxerFullName;
    _boxer = boxer;
}

-(void)setFighterLabelText
{
    self.fighterNameLabel.text = self.boxer.boxerFullName;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)setup
{
    [[NSBundle mainBundle] loadNibNamed:@"FighterPickControlsView" owner:self options:nil];
    [self addSubview:self.view];
    self.fighterNameLabel.text = self.boxer.boxerFullName;
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (IBAction)pickFighter:(id)sender {
    if ([delegate respondsToSelector:@selector(fighterChosen:)]) {
        [delegate fighterChosen:self.boxer];
    }
}
@end
