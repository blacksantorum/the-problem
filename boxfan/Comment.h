//
//  Comment.h
//  boxfan
//
//  Created by Chris Tibbs on 1/24/14.
//  Copyright (c) 2014 Chris Tibbs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Comment : NSObject

@property NSInteger commentID;
@property (nonatomic,strong) NSDate *date;
@property (nonatomic,strong) NSString *content;
@property (nonatomic,strong) User *author;
@property BOOL isJabbedByLoggedInUser;
@property NSInteger jabs;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;


@end
