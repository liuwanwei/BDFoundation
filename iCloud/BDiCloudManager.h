//
//  WorkoutCloudManager.h
//  7MinutesWorkout
//
//  Created by sungeo on 15/8/5.
//  Copyright (c) 2015年 maoyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CloudKit/CloudKit.h>

@protocol BDiCloudRecordDataSource <NSObject>

@required

/**
 *  将需要存储到 iCloud 中的记录转换成 iCloud CKRecord 对象
 *
 *  @return converted CKRecord object
 */
- (CKRecord *)convertToiCloudRecordObject;

/**
 *  从网络查询得到的 iCloud CKRecord 对象，恢复成一个本地记录对象
 *
 *  @param record 从 iCloud 查询到的对象
 *
 *  @return 恢复后的对象实例
 */
- (instancetype)initFromiCloudRecordObject:(CKRecord *)record;

@end

@protocol BDiCloudDelegate <NSObject>

- (void)successfullySavedRecord:(CKRecord *)record;
- (void)didReceiveRecords:(NSArray *)results;

@end

@interface BDiCloudManager : NSObject

@property (nonatomic, assign) id<BDiCloudDelegate> delegate;

+ (instancetype)sharedInstance;

- (void)queryRecordsWithType:(NSString *)recordType;
- (void)addRecord:(CKRecord *)record;

@end
