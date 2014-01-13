//
//  FightDisplayVC.m
//  boxfan
//
//  Created by Chris Tibbs on 1/8/14.
//  Copyright (c) 2014 Chris Tibbs. All rights reserved.
//

#import "FightDisplayVC.h"

@interface FightDisplayVC ()

- (void)setUpView;

@end

@implementation FightDisplayVC

-(void)refresh
{
    NSURLRequest *request = [NSURLRequest requestWithURL:self.urlForRequest];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            NSLog(@"Connection error: %@", connectionError);
        } else {
            NSError *error = nil;
            id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            if (error) {
                NSLog(@"JSON parsing error: %@", error);
            } else {
                self.JSONdictionary = (NSDictionary *)object;
                // NSLog(@"%@",self.JSONarray);
                [self configureDataSource];
            }
        }
    }];
}

-(void)configureDataSource
{
    //
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self setUpView];
}

- (void)setUpView
{
    //
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
