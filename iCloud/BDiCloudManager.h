//
//  WorkoutCloudManager.h
//  7MinutesWorkout
//
//  Created by sungeo on 15/8/5.
//  Copyright (c) 2015年 maoyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CloudKit/CloudKit.h>

extern NSString * const CloudKitNotAvailableNote;   // 当前 Apple ID 的 CloudKit 未打开时广播此消息

@protocol BDiCloudDelegate <NSObject>

@optional

- (void)successfullySavedRecord:(CKRecord *)record;
- (void)saveRecord:(CKRecord *)record failedWithError:(NSError *)error;

- (void)didReceiveRecords:(NSArray *)results;
- (void)queryRecordsFailedWithError:(NSError *)error;


- (void)successfullyDeletedDefaultZone;

@end

@interface BDiCloudManager : NSObject

//@property (nonatomic) BOOL serviceReady;
@property (nonatomic, assign) id<BDiCloudDelegate> delegate;

@property (nonatomic, weak) CKContainer * container;
@property (nonatomic, weak) CKDatabase * privateDatabase;


+ (instancetype)sharedInstance;

- (void)queryRecordsWithType:(NSString *)recordType;
- (void)addRecord:(CKRecord *)record;

- (void)deleteDefaultRecordZone;

+ (BOOL)serviceReady;

@end
