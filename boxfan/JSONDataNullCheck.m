//
//  JSONDataNullCheck.m
//  boxfan
//
//  Created by Chris Tibbs on 1/21/14.
//  Copyright (c) 2014 Chris Tibbs. All rights reserved.
//

#import "JSONDataNullCheck.h"

@implementation JSONDataNullCheck

+(BOOL)isNull:(id)object
{
    return [object isKindOfClass:[NSNull class]];
}

@end
