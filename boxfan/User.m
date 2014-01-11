//
//  User.m
//  boxfan
//
//  Created by Chris Tibbs on 12/16/13.
//  Copyright (c) 2013 Chris Tibbs. All rights reserved.
//

#import "User.h"

@implementation User

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        _handle = [dictionary objectForKey:@"screen_name"];
        _name = [dictionary objectForKey:@"name"];
        _profileImageURL = [dictionary objectForKey:@"profile_image_url"];
    }
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.handle forKey:@"handle"];
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.profileImageURL forKey:@"profileImageURL"];
}

-(instancetype)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        _handle = [decoder decodeObjectForKey:@"handle"];
        _name = [decoder decodeObjectForKey:@"name"];
        _profileImageURL = [decoder decodeObjectForKey:@"profileImageURL"];
    }
    
    return self;
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"%@ %@ %@",self.handle,self.name,self.profileImageURL];
}

@end
