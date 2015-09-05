//
//  WorkoutCloudManager.m
//  7MinutesWorkout
//
//  Created by sungeo on 15/8/5.
//  Copyright (c) 2015年 maoyu. All rights reserved.
//

#import "BDiCloudManager.h"
#import <EXTScope.h>

NSString * const CloudKitNotAvailableNote = @"CloudKitNotAvailable";

static BOOL sIsServiceReady = NO;

@implementation BDiCloudManager{
}

+ (instancetype)sharedInstance{
    static BDiCloudManager * sInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (sInstance == nil) {
            sInstance = [[BDiCloudManager alloc] init];
        }
    });
    
    return sInstance;
}

- (instancetype)init{
    if (self = [super init]) {
        _container = [CKContainer defaultContainer];
        _privateDatabase = [_container privateCloudDatabase];
    }
    
    return self;
}


/**
 *  从 iCloud CloudKit 服务查询所有训练结果
 */
- (void)queryRecordsWithType:(NSString *)recordType{
    @weakify(self);
    
    [_container accountStatusWithCompletionHandler:^(CKAccountStatus accountStatus, NSError * error){
        @strongify(self);
        if (accountStatus == CKAccountStatusAvailable) {
            // 设备账号的 iCloud 服务可用，查询所有数据
            NSPredicate * predict = [NSPredicate predicateWithValue:YES];
            CKQuery * query = [[CKQuery alloc] initWithRecordType:recordType predicate:predict];
            
            // TODO: 当返回结果达到几百个时，要用 CKQueryOperation 查询，详见本调用文档
            [_privateDatabase performQuery:query  inZoneWithID:nil completionHandler:^(NSArray * results, NSError * error){                
                if (error) {
                    NSLog(@"查询记录失败: %@: %@", NSStringFromSelector(_cmd), error);
                    if (_delegate && [_delegate respondsToSelector:@selector(queryRecordsFailedWithError:)]) {
                        [_delegate queryRecordsFailedWithError:error];
                    }
                    
                }else{
                    if (self.delegate && [self.delegate respondsToSelector:@selector(didReceiveRecords:)]) {
                        [self.delegate performSelector:@selector(didReceiveRecords:) withObject:results];
                    }
                    
                    sIsServiceReady = YES;
                }
            }];
        }
        else{
            NSLog(@"账户没有 iCloudKit 权限");
            [self postCloudKitNotAvailableNotification];
        }
    }];
}

/**
 *  将新的训练结果保存到 iCloud 中去
 *
 *  @param result WorkoutResult object
 */
- (void)addRecord:(CKRecord *)record{
    // 先查用户是否有权限，再做后续动作
    [_container accountStatusWithCompletionHandler:^(CKAccountStatus accountStatus, NSError * error){
        if (accountStatus == CKAccountStatusAvailable) {
            [_privateDatabase saveRecord:record completionHandler:^(CKRecord * record, NSError * error){
                if (error) {
                    NSLog(@"添加记录失败：%@, An error occured in %@: %@", record.recordType, NSStringFromSelector(_cmd), error);
                    if (_delegate && [_delegate respondsToSelector:@selector(saveRecord:failedWithError:)]) {
                        [_delegate performSelector:@selector(saveRecord:failedWithError:) withObject:record withObject:error];
                    }
                    
                }else{
                    NSLog(@"添加记录成功：%@", record.recordType);
                    if (self.delegate && [self.delegate respondsToSelector:@selector(successfullySavedRecord:)]) {
                        [self.delegate performSelector:@selector(successfullySavedRecord:) withObject:record];
                    }
                    
                    sIsServiceReady = YES;
                }
            }];
        }
        else{
            NSLog(@"账户没有 iCloudKit 权限");
        }
    }];
}

- (void)deleteDefaultRecordZone{
    [_container accountStatusWithCompletionHandler:^(CKAccountStatus accountStatus, NSError * error){
        [_privateDatabase deleteRecordZoneWithID:[CKRecordZone defaultRecordZone].zoneID completionHandler:^(CKRecordZoneID * recordZoneID, NSError * error){
            if (error) {
                NSLog(@"删除默认存储空间失败");
            }else{
                NSLog(@"删除默认存储空间成功");
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(successfullyDeletedDefaultZone)]) {
                    [self.delegate performSelector:@selector(successfullyDeletedDefaultZone)];
                }
            }
        }];
    }];
}

- (void)postCloudKitNotAvailableNotification{
    [[NSNotificationCenter defaultCenter] postNotificationName:CloudKitNotAvailableNote object:self];
}

+ (BOOL)serviceReady{
    return sIsServiceReady;
}

@end
