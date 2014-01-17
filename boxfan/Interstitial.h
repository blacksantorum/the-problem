//
//  Interstitial.h
//  boxfan
//
//  Created by Chris Tibbs on 1/16/14.
//  Copyright (c) 2014 Chris Tibbs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@protocol InterstitialPassUser <NSObject>

-(void)passUser:(User *)user;

@end

@interface Interstitial : UIViewController <PFLogInViewControllerDelegate> 

@property (nonatomic,assign) id delegate;

@end
