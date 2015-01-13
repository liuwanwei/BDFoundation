//
//  MBProgressManager.h
//  Date
//
//  Created by maoyu on 12-11-21.
//  Copyright (c) 2012年 Liu&Mao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MBProgressManager : NSObject

+ (MBProgressManager *)defaultManager;

/************** HUD *******************/

// 默认使用application window。缺点：通过UIAlertView方式显示时，会被强制关闭。
- (void)showHUD:(NSString *)msg;

- (void)showHUD:(NSString *)msg withView:(UIView *)view;
- (void)removeHUD;

// 推荐!!!
+ (void)showHUD:(NSString *)msg inView:(UIView *)view;
+ (void)removeHUD;

/**************** Toast ***************/

// 默认使用application window。缺点：通过UIAlertView方式显示时，会被强制关闭。
- (void)showToast:(NSString *)msg;

- (void)showToast:(NSString *)msg withView:(UIView *)view;

// 推荐：在一定时间内展示文字提示!!!
+ (void)toast:(NSString *)toast inView:(UIView *)view;
+ (void)toast:(NSString *)toast delay:(NSTimeInterval)delay inView:(UIView *)view;

- (void)showIndicator;
- (void)hideIndicator;
@end
