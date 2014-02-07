//
//  BoxFanRevealController.m
//  boxfan
//
//  Created by Chris Tibbs on 1/16/14.
//  Copyright (c) 2014 Chris Tibbs. All rights reserved.
//

#import "BoxFanRevealController.h"
#import "Reachability.h"

@interface BoxFanRevealController () {
    UIAlertView *networkAvailableAlertView;
}

@property (nonatomic) Reachability *hostReachability;
@property (nonatomic,strong) UIToolbar *noConnectionToolbar;

@end

@implementation BoxFanRevealController

- (UIToolbar *)noConnectionToolbar
{
    if (!_noConnectionToolbar) {
        _noConnectionToolbar = [[UIToolbar alloc] init];
        _noConnectionToolbar.barStyle = UIBarStyleDefault;
        _noConnectionToolbar.translucent = YES;
        
        [_noConnectionToolbar sizeToFit];
        
        CGFloat toolbarHeight = [_noConnectionToolbar frame].size.height;
        
        CGRect rootViewBounds = self.view.bounds;
        CGFloat rootViewHeight = CGRectGetHeight(rootViewBounds);
        CGFloat rootViewWidth = CGRectGetWidth(rootViewBounds);
        CGRect rectArea = CGRectMake(0, rootViewHeight - toolbarHeight, rootViewWidth, toolbarHeight);
        
        UILabel *errorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 250, 32)];
        errorLabel.text = @"Your connection is down for the count";
        errorLabel.font = [UIFont systemFontOfSize:14.0];
        
        UIImageView *errorIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"connectionerror"]];
        
        UIBarButtonItem *labelItem = [[UIBarButtonItem alloc] initWithCustomView:errorLabel];
        UIBarButtonItem *errorIconItem = [[UIBarButtonItem alloc] initWithCustomView:errorIcon];
        
        NSArray *items = [NSArray arrayWithObjects:errorIconItem,labelItem,nil];
        _noConnectionToolbar.items = items;
        
        [_noConnectionToolbar setFrame:rectArea];
    }
    return  _noConnectionToolbar;
}

-(NSData *)encodedUserFromDefaults
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"User"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    NSString *remoteHostName = @"62.116.130.8";
    self.hostReachability = [Reachability reachabilityWithHostName:remoteHostName];
    [self.hostReachability startNotifier];
}

- (void) reachabilityChanged:(NSNotification *)note
{
	Reachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
	if ([curReach currentReachabilityStatus] == NotReachable) {
        [self.view addSubview:self.noConnectionToolbar];
    } else {
        [networkAvailableAlertView dismissWithClickedButtonIndex:0 animated:YES];
        [self.noConnectionToolbar removeFromSuperview];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"connectionRestored" object:self];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}

@end
