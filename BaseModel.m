//
//  BaseModel.m
//  MallCommunicationLibrary
//
//  Created by maoyu on 14-7-28.
//  Copyright (c) 2014年 yuteng. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

- (id)initWithUUID{
    if (self = [super init]) {
        CFUUIDRef uuid = CFUUIDCreate(NULL);
        NSString *uuidStr = (__bridge_transfer NSString *)CFUUIDCreateString(NULL, uuid);
        self.iid = uuidStr;
        CFRelease(uuid);
        
        self.createDate = [NSDate date];
    }
    
    return self;
}

@end
