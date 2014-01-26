//
//  TBACommentsMultipleVC.m
//  boxfan
//
//  Created by Chris Tibbs on 1/25/14.
//  Copyright (c) 2014 Chris Tibbs. All rights reserved.
//

#import "TBACommentsMultipleVC.h"
#import "MostJabbedCommentsDisplayVC.h"
#import "NewCommentsDisplayVC.h"
#import "CommentsDisplayVC.h"

@interface TBACommentsMultipleVC ()

@property (weak, nonatomic) IBOutlet UITextField *addCommentTextField;

- (IBAction)addCommentButtonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;

@end

@implementation TBACommentsMultipleVC

- (UIStoryboard *)storyboard
{
    return [UIStoryboard storyboardWithName:@"Main" bundle:nil];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    NSMutableArray *initialViewController = [NSMutableArray array];
    
    NSLog(@"Fight, during awakeFromNib %@",self.fight);
    
    MostJabbedCommentsDisplayVC *mostController = [self.storyboard instantiateViewControllerWithIdentifier:@"jabbed"];
    mostController.title = @"Jabbed";
    mostController.fight = self.fight;
    NewCommentsDisplayVC *newController = [self.storyboard instantiateViewControllerWithIdentifier:@"new"];
    newController.title = @"New";
    newController.fight = self.fight;
    
    [initialViewController addObject:mostController];
    [initialViewController addObject:newController];
    
    self.viewController = initialViewController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    for (CommentsDisplayVC *c in self.viewController) {
        c.fight = self.fight;
    }
    
    
	// Do any additional setup after loading the view.
}

- (IBAction)addCommentButtonPressed:(id)sender {
}
@end
