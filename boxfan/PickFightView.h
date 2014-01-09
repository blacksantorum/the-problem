//
//  PickFightView.h
//  boxfan
//
//  Created by Chris Tibbs on 1/9/14.
//  Copyright (c) 2014 Chris Tibbs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Boxer.h"

@interface PickFightView : UIView

@property (nonatomic,strong) IBOutlet UIView *view;
@property (nonatomic,strong) Boxer *boxer;

@end
