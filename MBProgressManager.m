//
//  MBProgressManager.m
//  Date
//
//  Created by maoyu on 12-11-21.
//  Copyright (c) 2012年 Liu&Mao. All rights reserved.
//

#import "MBProgressManager.h"
#import "MBProgressHUD.h"

static MBProgressManager *sMBProgressManager;

@implementation MBProgressManager {
    MBProgressHUD *_HUD;
}

+ (MBProgressManager *)defaultManager {
    if (nil == sMBProgressManager) {
        sMBProgressManager = [[MBProgressManager alloc] init];
    }
    
    return sMBProgressManager;
}

#pragma 类成员函数
- (void)showHUD:(NSString *)msg {
    [self showIndicator];
    if (nil == _HUD) {
         _HUD = [[MBProgressHUD alloc] initWithWindow:[UIApplication sharedApplication].keyWindow];
        _HUD.removeFromSuperViewOnHide = NO;
    }else {
        [_HUD removeFromSuperview];
    }
    
    [[UIApplication sharedApplication].keyWindow addSubview:_HUD];
    
    _HUD.labelText = msg;
    [_HUD show:YES];
}

- (void)removeHUD {
    [self hideIndicator];
    [_HUD hide:YES];
    [_HUD removeFromSuperViewOnHide];
    _HUD = nil;
}

- (void)showHUD:(NSString *)msg withView:(UIView *)view {
    [self showIndicator];
    if (nil == _HUD) {
        _HUD = [[MBProgressHUD alloc] initWithWindow:[UIApplication sharedApplication].keyWindow];
    }else {
        [_HUD removeFromSuperview];
    }
    [view addSubview:_HUD];
    _HUD.labelText = msg;
    [_HUD show:YES];
}

+ (void)showHUD:(NSString *)msg inView:(UIView *)view{
    MBProgressManager * pm = [MBProgressManager defaultManager];
    [pm showHUD:msg withView:view];
}

+ (void)removeHUD{
    MBProgressManager * pm = [MBProgressManager defaultManager];
    [pm removeHUD];
}

- (void)showToast:(NSString *)msg {
    [self showHUD:msg];
    [self performSelector:@selector(removeHUD) withObject:self afterDelay:3];
}

- (void)showToast:(NSString *)msg withView:(UIView *)view {
    [self showHUD:msg withView:view];
    [self performSelector:@selector(removeHUD) withObject:self afterDelay:1];
}

- (void)showIndicator {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)hideIndicator {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

@end
