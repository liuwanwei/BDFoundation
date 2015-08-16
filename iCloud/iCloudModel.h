//
//  iCloudModel.h
//  WeightMaster
//
//  Created by sungeo on 15/8/16.
//  Copyright (c) 2015年 buddysoft. All rights reserved.
//

#import "BaseModel.h"

@interface iCloudModel : BaseModel

/**
 *  是否已经成功保存到了 iCloud 上
 */
@property (nonatomic, strong) NSNumber * savedToICloud;

@end
