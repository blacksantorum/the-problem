//
//  BoxFanRevealController.h
//  boxfan
//
//  Created by Chris Tibbs on 1/16/14.
//  Copyright (c) 2014 Chris Tibbs. All rights reserved.
//

#import "PKRevealController.h"
#import "User.h"
#import "Interstitial.h"

@interface BoxFanRevealController : PKRevealController <InterstitialPassUser>

@property (strong,nonatomic) User *loggedInUser;

@end
