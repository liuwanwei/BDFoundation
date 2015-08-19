//
//  WorkoutCloudManager.m
//  7MinutesWorkout
//
//  Created by sungeo on 15/8/5.
//  Copyright (c) 2015年 maoyu. All rights reserved.
//

#import "BDiCloudManager.h"
//#import "WorkoutResult.h"
#import <EXTScope.h>

static NSString * const AllRecords = @"TRUEPREDICATE";

@implementation BDiCloudManager{
    __weak CKContainer * _container;
    __weak CKDatabase * _privateDatabase;
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
            
            [_privateDatabase performQuery:query  inZoneWithID:nil completionHandler:^(NSArray * results, NSError * error){                
                if (error) {
                    NSLog(@"An error occured in %@: %@", NSStringFromSelector(_cmd), error);
                }else{
                    if (self.delegate && [self.delegate respondsToSelector:@selector(didReceiveRecords:)]) {
                        [self.delegate performSelector:@selector(didReceiveRecords:) withObject:results];
                    }
                    
                    _serviceReady = YES;
                }
            }];
        }
        else{
            NSLog(@"账户没有 iCloudKit 权限");
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
                }else{
                    NSLog(@"添加记录成功：%@", record.recordType);
                    if (self.delegate && [self.delegate respondsToSelector:@selector(successfullySavedRecord:)]) {
                        [self.delegate performSelector:@selector(successfullySavedRecord:) withObject:record];
                    }
                    
                    _serviceReady = YES;
                }
            }];
        }
        else{
            NSLog(@"账户没有 iCloudKit 权限");
        }
    }];
}


@end
