//
//  Utils.h
//  investigation
//
//  Created by sungeo on 14/12/4.
//  Copyright (c) 2014年 buddysoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UITableView;

@interface Utils : NSObject

// 从Main Storyboard中加载一个UIViewController
+ (id)viewControllerWithIdentifier:(NSString *)identifier;

// 展示一个UIAlertView
+ (void)warningWithMessage:(NSString *)message;
+ (void)warningWithTitle:(NSString *)title message:(NSString *)message;
+ (void)errorWithMessage:(NSString *)message;

+ (void)hideExtraCellsForTableView:(UITableView *)tableView;

/*
 * 将秒数转换为"XX小时XX分XX秒"这样的形式
 */
+ (NSString *)readableTimeFromSeconds:(NSTimeInterval)interval;

+ (void)customizeStatusBarForApplication:(id)application;
+ (void)customizeNavigationBarForApplication:(id)application withColor:(id)color;

@end
