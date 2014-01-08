//
//  FightDetailViewController.m
//  boxfan
//
//  Created by Chris Tibbs on 12/16/13.
//  Copyright (c) 2013 Chris Tibbs. All rights reserved.
//

#import "FightDetailViewController.h"
#import "Fight.h"
#import "Boxer.h"
#import "Pick.h"
#import <AFHTTPRequestOperationManager.h>



@interface FightDetailViewController ()

# pragma mark - Pick Controls/Display

@property (strong,nonatomic) UIWebView *webView;
@property (strong,nonatomic) NSURL *authURL;

@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *weightAndRoundsLabel;
// A-side controls
@property (weak, nonatomic) IBOutlet UILabel *fighterALabel;
- (IBAction)pickFighterAByStoppage:(UIButton *)sender;
- (IBAction)pickFighterAByDecision:(UIButton *)sender;

// B-side controls
@property (weak, nonatomic) IBOutlet UILabel *fighterBLabel;
- (IBAction)pickFighterBByStoppage:(UIButton *)sender;
- (IBAction)pickFighterBByDecision:(UIButton *)sender;

# pragma mark - Community Picks Collections

// Top users who picked A-side
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *topUsersWhoPickedFighterAByStoppage;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *topUsersWhoPickedFighterAByDecision;

// Top users who picked B-side
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *topUsersWhoPickedFighterBByStoppage;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *topUsersWhoPickedFighterBByDecision;

@end

@implementation FightDetailViewController

-(NSURL *)authURL
{
    return [NSURL URLWithString:@"http://the-boxing-app.herokuapp.com/auth/twitter"];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)placeWebViewOnView
{
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(30, 30, 250, 600)];
    NSURLRequest *request = [NSURLRequest requestWithURL:self.authURL];
    [self.webView loadRequest:request];
    
    [self.view addSubview:self.webView];
    
}

-(void)displayCookies
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [cookieJar cookiesForURL:self.authURL]) {
        NSData *cookieEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:cookie];
        
        [userDefaults setObject:cookieEncodedObject forKey:@"MySavedCookies"];
        NSLog(@"%@",[userDefaults objectForKey:@"MySavedCookies"]);
    }
}

-(void)saveCookies
{
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [cookieJar cookiesForURL:self.authURL]) {
        NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
        [cookieProperties setObject:cookie.name forKey:NSHTTPCookieName];
        [cookieProperties setObject:cookie.value forKey:NSHTTPCookieValue];
        [cookieProperties setObject:cookie.domain forKey:NSHTTPCookieDomain];
        [cookieProperties setObject:[NSURL URLWithString:@"the-boxing-app.herokuapp.com/auth/twitter"] forKey:NSHTTPCookieOriginURL];
        [cookieProperties setObject:cookie.path forKey:NSHTTPCookiePath];
        [cookieProperties setObject:[[NSDate date] dateByAddingTimeInterval:2629743] forKey:NSHTTPCookieExpires];
        
        NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
    }

}

-(void)makeHardCodedPick
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"pick":@{@"winner_id": @8, @"loser_id":@9, @"ko":@"true" }};
    [manager POST:@"http://the-boxing-app.herokuapp.com/fights/6/picks" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (IBAction)closeWebView:(id)sender {
    [self.webView removeFromSuperview];
    // [self makeHardCodedPick];
    [self saveCookies];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // set title, fight descriptors
    [self displayCookies];
    [self setTitle:[self.fight titleForScheduleView]];
    [self.locationLabel setText:self.fight.location];
    [self.weightAndRoundsLabel setText:[NSString stringWithFormat:@"%@ rounds at %@lbs",self.fight.rounds,self.fight.weight]];
    
	// set fighter labels
    Boxer *a = [self.fight.boxers objectAtIndex:0];
    [self.fighterALabel setText:[a boxerFullName]];
    
    Boxer *b = [self.fight.boxers objectAtIndex:1];
    [self.fighterBLabel setText:[b boxerFullName]];
    
    [self placeWebViewOnView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pickFighterAByStoppage:(UIButton *)sender {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"foo": @"bar"};
    [manager POST:@"http://example.com/resources.json" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (IBAction)pickFighterAByDecision:(UIButton *)sender {
}
- (IBAction)pickFighterBByStoppage:(UIButton *)sender {
}

- (IBAction)pickFighterBByDecision:(UIButton *)sender {
}
@end
