//
//  BaseModel.h
//  MallCommunicationLibrary
//
//  Created by maoyu on 14-7-28.
//  Copyright (c) 2014年 yuteng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AutoCoding.h>

#define kId                 @"id"
#define kName               @"name"
#define kIndex              @"index"
#define kTitle              @"title"
#define kStatus             @"status"
#define kCreateTime         @"createTime"
#define kAnswerOptions      @"answerOptions"

@interface BaseModel : NSObject

@property (nonatomic, copy) NSString * id;          // id , deprecated, use iid instead
@property (nonatomic, copy) NSString * iid;         // index id的简写

@property (nonatomic, copy) NSString * createTime;  // 字符串类型，可用于通信协议中

/**
 *  NSDate 类型，可以通过通过 AutoCoding 库序列化后存储在本地。
 *  代表数据创建的时间，只有主动使用 initWithUUID 初始化对象时，才会被赋初值。
 *  在网络通信中传输时间属性时，请使用 createTime 属性。
 */
@property (nonatomic, strong) NSDate * createDate;

@property (nonatomic, weak) id parentObject;

- (id)initWithUUID;

@end
