//
//  LogInViewController.m
//  boxfan
//
//  Created by Chris Tibbs on 12/27/13.
//  Copyright (c) 2013 Chris Tibbs. All rights reserved.
//

#import "LogInViewController.h"
#import "ReleasingWebView.h"
#import <AFHTTPRequestOperationManager.h>

@interface LogInViewController ()

@property (strong,nonatomic) NSURL *authURL;
@property (strong,nonatomic) ReleasingWebView *webView;
@property (strong,nonatomic) NSHTTPCookieStorage *cookieJar;

-(void)placeWebViewOnLoginScreen;

@end

@implementation LogInViewController

-(NSHTTPCookieStorage *)cookieJar
{
    if (!_cookieJar) {
        _cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    }
    return _cookieJar;
}
- (IBAction)makePost:(id)sender {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"pick":@{@"winner_id": @8, @"loser_id":@9, @"ko":@"true" }};
    [manager POST:@"http://the-boxing-app.herokuapp.com/fights/6/picks" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (IBAction)releaseWebViewButton:(id)sender {
    [self.webView removeFromSuperview];
     NSLog(@"New cookies: %@",self.cookieJar.cookies);
}

-(void)placeWebViewOnLoginScreen
{
    NSLog(@"Initial cookies: %@",self.cookieJar.cookies);
    self.webView = [[ReleasingWebView alloc] initWithFrame:CGRectMake(0, 0, 200, 400)];
    NSURLRequest *request = [NSURLRequest requestWithURL:self.authURL];
    [self.webView loadRequest:request];
    
    [self.view addSubview:self.webView];
}

-(NSURL *)authURL
{
    return [NSURL URLWithString:@"http://the-boxing-app.herokuapp.com/auth/twitter"];
}

- (IBAction)logInWithTwitter:(UIButton *)sender {
    [self placeWebViewOnLoginScreen];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.cookieJar addObserver:self.webView forKeyPath:@"cookies" options:NSKeyValueObservingOptionNew context:NULL];
}

@end
