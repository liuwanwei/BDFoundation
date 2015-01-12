//
//  BaseOperation.h
//  tang
//
//  Created by maoyu on 13-12-18.
//  Copyright (c) 2013年 diandi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseResponse.h"
#import "ASINetworkQueue.h"
#import "ASIFormDataRequest.h"

#define DEV_MODE                    0
#ifdef  DEV_MODE
#define HOST_NAME                   @"http://test.investigation.bl99w.com/"
#else
#define HOST_NAME                   @"http://investigation.bl99w.com/"
#endif

#define SUCCESS                     0
#define ERROR                       -1
#define ERROR_EMPTY                 -2

#define LIMIT                       18
#define DefaultTimeoutSeconds       15.0

typedef enum{
    RequestTypeInvalid = -1,
    RequestTypeGet = 0,
    RequestTypePost = 1,
}RequestType;

@class BaseOperation;

@protocol OperationDelegate <NSObject>

@optional
- (void)didSucceed:(BaseOperation *)operation;
- (void)didFail:(BaseOperation *)operation;

@end

@protocol OperationDataSource <NSObject>

@required
- (RequestType)requestType;             // 请求类型
- (NSDictionary *)requestParam;         // 请求参数
- (NSString *)requestPath;              // url路径
- (Class)responseClass;                 // 反馈包解析类原型。

@optional   // TODO: 这个是个典型的delegate事件，不该放到datasource
- (void)afterSucceed;                   // 派生类对返回内容做处理的时机，代替之前的didSucceed.

@end


@interface BaseOperation : NSObject

@property (nonatomic) NSTimeInterval requestTimeoutSeconds;

@property (nonatomic, weak) id <OperationDelegate> delegate;

// POST请求需要发送认证信息时设置为YES
@property (nonatomic) BOOL needUserAuthInfo;
@property (nonatomic, strong) BaseResponse * response;
@property (nonatomic, copy) void (^completion)(BaseResponse * resp);

// 启动请求
- (BOOL)startRequest:(id<OperationDelegate>)delegate;
- (BOOL)startRequest:(id<OperationDelegate>)delegate withCompletion:(void (^)(BaseResponse *))completion;
//- (BOOL)startRequestWithCompletion:(void (^)(BaseOperation *))completion;

@end
