//
//  UIView+Additional.h
//  elap
//
//  Created by maoyu on 15/6/19.
//  Copyright (c) 2015年 maoyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Additional)

// 显示倒圆角
- (void)makeCornorRadius:(CGFloat)radius;

- (void)makeCircle;

// 添加外边框线
- (void)addBorderWithWidth:(NSInteger)width withColor:(UIColor *)color;

// 添加单击事件
- (void)addAction:(SEL)action target:(id)target;

@end
