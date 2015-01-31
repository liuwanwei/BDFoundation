//
//  BaseModel.m
//  MallCommunicationLibrary
//
//  Created by maoyu on 14-7-28.
//  Copyright (c) 2014年 yuteng. All rights reserved.
//

#import "BaseModel.h"
#import "AutoCoding.h"

@implementation BaseModel

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    [self setWithCoder:aDecoder];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    for (NSString *key in [self codableProperties])
    {
        id object = [self valueForKey:key];
        if (object) [aCoder encodeObject:object forKey:key];
    }
}

@end
