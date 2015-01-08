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

typedef enum {
    StateWaiting = 0,
    StateFinished = 1
}State;

typedef enum{
    RequestTypeInvalid = -1,
    RequestTypeGet = 0,
    RequestTypePost = 1,
}RequestType;

@class BaseOperation;

@protocol OperationDelegate

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

@optional
- (void)afterSucceed;                   // 派生类对返回内容做处理的时机，代替之前的didSucceed.

@end

@interface BaseOperation : NSObject

@property (nonatomic) NSTimeInterval requestTimeoutSeconds;

@property (nonatomic, weak) id <OperationDelegate> delegate;

@property (nonatomic) NSInteger code;
@property (nonatomic) State state;

/* POST请求是否需要发送认证信息，不需要自动设置认证消息的Post Operation，请设置该属性为NO */
@property (nonatomic) BOOL needUserAuthInfo;

/* 反馈包 */
@property (nonatomic, strong) BaseResponse * response;

- (BOOL)startRequest:(id <OperationDelegate>)delegate;

- (ASIHTTPRequest *)createRequest;
- (void)requestDidFinish:(ASIHTTPRequest *)request;
- (void)requestDidFail:(ASIHTTPRequest *)request;

- (NSURL *)makeGetApiUrl:(NSString *)subUrl withParams:(NSDictionary *)params;
- (NSURL *)makePostApiUrl:(NSString *)subUrl;
- (NSDictionary *)getResultWithRequest:(ASIHTTPRequest *)request;
- (NSDictionary *)getBodyWithResult:(NSDictionary *)result;
- (NSInteger)getTotalWithBody:(NSDictionary *)body;
- (NSArray *)getRowsWithBody:(NSDictionary *)body;

- (ASIHTTPRequest *)createGetRequestWithParam:(NSDictionary *)params;
- (ASIHTTPRequest *)createPostRequestWithParam:(NSDictionary *)params;

@end
