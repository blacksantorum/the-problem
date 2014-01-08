//
//  Boxer.h
//  boxfan
//
//  Created by Chris Tibbs on 12/15/13.
//  Copyright (c) 2013 Chris Tibbs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Boxer : NSObject

@property (nonatomic,strong) NSString *boxerID;
@property (nonatomic,strong) NSString *firstName;
@property (nonatomic,strong) NSString *lastName;
@property (nonatomic,strong) NSString *country;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSString *)boxerFullName;

@end
