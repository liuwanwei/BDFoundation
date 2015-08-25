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

// 可自定义停留时间的toast
+ (void)toast:(NSString *)toast delay:(NSTimeInterval)delay inView:(UIView *)view{
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = toast;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:delay];
}

// 简单封装：展示1.5秒后自动消失的toast
+ (void)toast:(NSString *)toast inView:(UIView *)view{
    [MBProgressManager toast:toast delay:1.5f inView:view];
}



- (void)showIndicator {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)hideIndicator {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)stopHUDWithSuccessMessage:(NSString *)message{
    [self hideIndicator];
    _HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
    _HUD.mode = MBProgressHUDModeCustomView;
    _HUD.labelText = message;
    [_HUD removeFromSuperViewOnHide];
    [_HUD hide:YES afterDelay:1];
    _HUD = nil;
}

- (void)showSuccessMessage:(NSString *)message {
    if (nil == _HUD) {
        _HUD = [[MBProgressHUD alloc] initWithWindow:[UIApplication sharedApplication].keyWindow];
    }else {
        [_HUD removeFromSuperview];
    }
    
    [[UIApplication sharedApplication].keyWindow addSubview:_HUD];
    
    _HUD.mode = MBProgressHUDModeCustomView;
    _HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
    _HUD.labelText = message;
    [_HUD removeFromSuperViewOnHide];
    [_HUD show:YES];
    [_HUD hide:YES afterDelay:1];
}

@end
