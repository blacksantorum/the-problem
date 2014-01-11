//
//  LoginViewController.m
//  boxfan
//
//  Created by Chris Tibbs on 1/10/14.
//  Copyright (c) 2014 Chris Tibbs. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation LoginViewController

-(NSURLRequest *)authRequest
{
    NSURL *authURL = [NSURL URLWithString:@"http://the-boxing-app.herokuapp.com/auth/twitter"];
    NSURLRequest *authRequest = [NSURLRequest requestWithURL:authURL];
    return authRequest;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.webView loadRequest:[self authRequest]];
}



- (IBAction)doneButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
