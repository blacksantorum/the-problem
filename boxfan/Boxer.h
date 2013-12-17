//
//  Boxer.h
//  boxfan
//
//  Created by Chris Tibbs on 12/15/13.
//  Copyright (c) 2013 Chris Tibbs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Boxer : NSObject

@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *country;

-(instancetype)initWithFirst:(NSString *)first
                        Last:(NSString *)last
                     Country:(NSString *)country;

-(NSString *)boxerFullName;

@end
