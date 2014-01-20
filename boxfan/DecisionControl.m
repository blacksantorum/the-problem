//
//  DecisionControl.m
//  boxfan
//
//  Created by Chris Tibbs on 1/17/14.
//  Copyright (c) 2014 Chris Tibbs. All rights reserved.
//

#import "DecisionControl.h"
#import "Boxer.h"

@interface DecisionControl()



@end

@implementation DecisionControl

@synthesize delegate;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"DecisionControl" owner:self options:nil];
        [self addSubview:self.view];
        
    }
    return self;
}



- (IBAction)decisionButtonPressed:(id)sender {
    if ([delegate respondsToSelector:@selector(makeDecision:)]) {
        [delegate makeDecision:self.fight];
    }
}
@end
