//
//  User.h
//  boxfan
//
//  Created by Chris Tibbs on 12/16/13.
//  Copyright (c) 2013 Chris Tibbs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Fight.h"

@interface User : NSObject

@property (nonatomic, strong) NSString *handle;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) Fight *fightOfTheYear;
@property (nonatomic) NSUInteger *score;

@end
