//
//  UpdateProfileViewController.h
//  boxfan
//
//  Created by Chris Tibbs on 1/27/14.
//  Copyright (c) 2014 Chris Tibbs. All rights reserved.
//

@protocol UpdateProfileDelegate <NSObject>

- (void)updateProfile:(NSDictionary *)dictionary;

@end

#import <UIKit/UIKit.h>

@interface UpdateProfileViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *mantraTextField;
@property (weak, nonatomic) IBOutlet UITextField *firstFightTextField;
@property (weak, nonatomic) IBOutlet UITextField *favoriteBoxerTextField;
@property (weak, nonatomic) IBOutlet UITextField *favoriteFightTextField;

@property (strong,nonatomic) NSString *mantra;
@property (strong,nonatomic) NSString *firstFight;
@property (strong,nonatomic) NSString *favoriteBoxer;
@property (strong,nonatomic) NSString *favoriteFight;


@property (nonatomic,assign)id delegate;

@end
