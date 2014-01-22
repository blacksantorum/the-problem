//
//  FightDisplayVC.h
//  boxfan
//
//  Created by Chris Tibbs on 1/8/14.
//  Copyright (c) 2014 Chris Tibbs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fight.h"
#import "Pick.h"
#import "BoxFanRevealController.h"

@interface FightDisplayVC : UIViewController <UITableViewDataSource,UITableViewDataSource>

@property (strong,nonatomic) Fight *fight;
@property (strong,nonatomic)  User *loggedInUser;
@property (strong,atomic) NSURL *urlForRequest;
@property (strong,atomic) NSDictionary *JSONdictionary;
@property (strong,nonatomic) Pick *pick;

@property (strong,nonatomic) Boxer *boxerA;
@property (strong,nonatomic) Boxer *boxerB;

@property (weak, nonatomic) IBOutlet UITableView *fightInfoTableView;

-(void)configureDataSource;

@end
