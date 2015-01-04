//
//  DomainManager.m
//  investigation
//
//  Created by sungeo on 14/12/30.
//  Copyright (c) 2014年 buddysoft. All rights reserved.
//

#import "DomainManager.h"

#define kDomain     @"HostnameIndex"

static NSMutableArray * sDomains = nil;
static int sDomainIndex = -1;

@interface DomainManager()

@end

@implementation DomainManager

+ (DomainManager *)defaultInstance{
    static DomainManager * sDefault = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (sDefault == nil) {
            sDefault = [[DomainManager alloc] init];
        }
    });
    
    return sDefault;
}

- (id)init{
    if (self = [super init]) {
        if (sDomains == nil) {
            sDomains = [[NSMutableArray alloc] init];
        }
        
        [self loadConfig];
    }
    
    return self;
}

- (void)loadConfig{
    // 从磁盘加载主机序号
    NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
    int index = [[ud objectForKey:kDomain] intValue];
    sDomainIndex = index;
}

- (NSArray *)domains{
    return [NSArray arrayWithArray:sDomains];
}

// 添加一个域名
- (void)addDomain:(NSString *)domain{
    if ([sDomains containsObject:domain]) {
        return;
    }else{
        [sDomains addObject:domain];
    }
}

// 设置当前使用域名
- (void)setCurrentDomain:(NSString *)domain{
    NSUInteger index = [sDomains indexOfObject:domain];
    if (index != NSNotFound) {
        sDomainIndex = (int)index;
        
        // 保存到磁盘中
        NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:[NSNumber numberWithInt:sDomainIndex] forKey:kDomain];
    }
}

- (NSString *)currentDomain{
    return sDomains[sDomainIndex];
}

@end
