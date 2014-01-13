//
//  Auth.h
//  boxfan
//
//  Created by Chris Tibbs on 1/11/14.
//  Copyright (c) 2014 Chris Tibbs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Auth : NSObject

+(NSString *)encryptedKeyForUser:(User *)user;
+(NSString *)sessionToken;

@end
