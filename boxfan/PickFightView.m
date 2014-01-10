//
//  PickFightView.m
//  boxfan
//
//  Created by Chris Tibbs on 1/9/14.
//  Copyright (c) 2014 Chris Tibbs. All rights reserved.
//

#import "PickFightView.h"

@interface PickFightView ()

@property (weak, nonatomic) IBOutlet UILabel *fighterNameLabel;

@end

@implementation PickFightView

@synthesize delegate;

-(void)setBoxer:(Boxer *)boxer
{
    self.fighterNameLabel.text = [NSString stringWithFormat:@"Pick %@?",boxer.boxerFullName];
    _boxer = boxer;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)setup
{
    [[NSBundle mainBundle] loadNibNamed:@"PickFightView" owner:self options:nil];
    [self addSubview:self.view];
}

- (IBAction)pickByKO:(id)sender {
    if ([delegate respondsToSelector:@selector(pickFighter:withKO:)]) {
        [delegate pickFighter:self.boxer withKO:YES];
    }
}

- (IBAction)pickByDecision:(id)sender {
    if ([delegate respondsToSelector:@selector(pickFighter:withKO:)]) {
        [delegate pickFighter:self.boxer withKO:NO];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
