//
//  FindUserVC.h
//  boxfan
//
//  Created by Chris Tibbs on 1/15/14.
//  Copyright (c) 2014 Chris Tibbs. All rights reserved.
//

#import "BoxingAppDVC.h"

@interface FindUserVC : BoxingAppDVC <UISearchDisplayDelegate,UISearchBarDelegate,UITableViewDataSource,UITableViewDataSource>


- (IBAction)userClickedShowSettings:(id)sender;


@end
