//
//  BaseModel.h
//  MallCommunicationLibrary
//
//  Created by maoyu on 14-7-28.
//  Copyright (c) 2014年 yuteng. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kId                 @"id"
#define kName               @"name"
#define kIndex              @"index"
#define kTitle              @"title"
#define kStatus             @"status"
#define kCreateTime         @"createTime"
#define kAnswerOptions      @"answerOptions"

@interface BaseModel : NSObject <NSCoding>

@property (nonatomic, copy) NSString * iid;         // index id的简写
@property (nonatomic, copy) NSString * createTime;

@property (nonatomic, weak) id parentObject;

- (id)initWithUUID;

@end
