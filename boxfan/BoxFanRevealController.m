//
//  BoxFanRevealController.m
//  boxfan
//
//  Created by Chris Tibbs on 1/16/14.
//  Copyright (c) 2014 Chris Tibbs. All rights reserved.
//

#import "BoxFanRevealController.h"

@interface BoxFanRevealController ()

@end

@implementation BoxFanRevealController

-(NSData *)encodedUserFromDefaults
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"User"];
}


-(void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    if (![self encodedUserFromDefaults]) {
        Interstitial *interstitial = [[Interstitial alloc] initWithNibName:@"Interstitial" bundle:nil];
        [self presentViewController:interstitial animated:YES completion:nil];
        interstitial.delegate = self;
    }
    
}

-(void)passUser:(User *)user
{
    self.loggedInUser = user;
    NSLog(@"User passed to BFRC: %@",self.loggedInUser);
}



@end
