//
//  UpdateProfileViewController.m
//  boxfan
//
//  Created by Chris Tibbs on 1/27/14.
//  Copyright (c) 2014 Chris Tibbs. All rights reserved.
//

#import "UpdateProfileViewController.h"

@interface UpdateProfileViewController ()

- (IBAction)tappedView:(id)sender;

@end

@implementation UpdateProfileViewController

- (IBAction)cancelButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveButtonPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(updateProfile:)])  {
        [self.delegate updateProfile:@{@"user":@{@"mantra":self.mantraTextField.text,@"favorite_fight":self.favoriteFightTextField.text,@"first_fight":self.firstFightTextField.text,@"favorite_boxer":self.favoriteBoxerTextField.text}}];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (IBAction)tappedView:(id)sender {
    [self.view endEditing:YES];
}
@end
