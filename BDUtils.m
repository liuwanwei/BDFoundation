//
//  Utils.m
//  investigation
//
//  Created by sungeo on 14/12/4.
//  Copyright (c) 2014年 buddysoft. All rights reserved.
//

#import "BDUtils.h"
#import <UIKit/UIKit.h>

@implementation BDUtils

+ (id)viewControllerWithIdentifier:(NSString *)identifier{
    return [BDUtils viewControllerwithStoryboard:@"Main" withIdentifier:identifier];
}

+ (id)viewControllerwithStoryboard:(NSString *)storyboard withIdentifier:(NSString *)identifier {
    UIStoryboard * mainStoryboard = [UIStoryboard storyboardWithName:storyboard bundle:nil];
    return [mainStoryboard instantiateViewControllerWithIdentifier:identifier];
}

+ (void)warningWithMessage:(NSString *)message{
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提醒" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

+ (void)warningWithTitle:(NSString *)title message:(NSString *)message{
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alertView show];
}

+ (void)errorWithMessage:(NSString *)message{
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"出错了" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

+ (void)hideExtraCellsForTableView:(UITableView *)tableView{
    // 隐藏多余的cell
    UIView * view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

+ (void)customizeBackNavigationItemTitle:(NSString *)title forViewController:(UIViewController *)vc{
    vc.navigationController.navigationBar.topItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:nil action:nil];
}

+ (void)customizeNavigationBarForApplication:(UIApplication *)application withColor:(UIColor *)color{
    // 自定义导航栏背景色、文字颜色
    // http://beyondvincent.com/2013/11/03/2013-11-03-120-customize-navigation-status-bar-ios-7/#6
    
    //  导航栏背景色，不使用 tintColor
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UINavigationBar appearance] setBarTintColor:color];
    
    // 导航按钮颜色：返回或item按钮颜色
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    // Title文字颜色
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
}

+ (void)customizeNavigationBarForApplication:(id)application withImage:(UIImage *)image {
    [[UINavigationBar appearance] setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    // 导航按钮颜色：返回或item按钮颜色
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    // Title文字颜色
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
}

+ (void)customizeStatusBarForApplication:(UIApplication *)application{
    // 自定义状态栏颜色（记得先修改plist，上面链接中有描述）
    [application setStatusBarHidden:NO];
    [application setStatusBarStyle:UIStatusBarStyleLightContent];

}


+ (NSString *)readableTimeFromSeconds:(NSTimeInterval)interval{
    long hour = interval / (60 * 60);
    long minute = ((long)interval % (60 * 60)) / 60;
//    long second = (long)interval % 60;
    
    if (hour == 0 && minute == 0) {
        return @"不到1分钟";
    }
    
    NSString * string = @"";
    if (hour != 0) {
        string = [string stringByAppendingFormat:@"%ld小时", hour];
    }
    
    if (minute != 0 || hour != 0) {
        string = [string stringByAppendingFormat:@"%ld分钟", minute];
    }
    
//    string = [string stringByAppendingFormat:@"%02ld秒", second];
    
    return string;
}

+ (void)loadHtml:(NSString *)fileName webView:(UIWebView *)webView {
    NSString * htmlPath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"html"];
    if (htmlPath) {
        NSString * appHtml  = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
        NSURL * baseURL     = [NSURL fileURLWithPath:htmlPath];
        [webView loadHTMLString:appHtml baseURL:baseURL];
    }
}

+ (void)loadHtmlWithFilePath:(NSString *)filePath webView:(UIWebView *)webView {
    NSString * appHtml = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSURL * baseURL = [NSURL fileURLWithPath:[[NSBundle mainBundle]  bundlePath]];
    [webView loadHTMLString:appHtml baseURL:baseURL];
}

+ (NSDictionary *)loadJsonFileFromBundel:(NSString *)fileName {
    NSDictionary * result = nil;
    
    NSString * dataFilePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"json"];
    if (dataFilePath) {
        NSData * data = [NSData dataWithContentsOfFile:dataFilePath];
        result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    }
    
    return result;
}

@end
