//
//  UIButton+Additional.h
//  elap
//
//  Created by maoyu on 15/5/6.
//  Copyright (c) 2015年 maoyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Additional)

// 显示圆形图像
- (void)makeCircle;
- (void)makeCircleWithBorderColor:(UIColor *)color withWidth:(CGFloat)width;

// 显示倒圆角
- (void)makeCornorRadius:(CGFloat)radius;

@end
