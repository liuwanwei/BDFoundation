//
//  UIButton.m
//  elap
//
//  Created by maoyu on 15/5/6.
//  Copyright (c) 2015年 maoyu. All rights reserved.
//

#import "UIButton+Additional.h"

@implementation UIButton (Additional)

- (void)addBorderWithWidth:(CGFloat)width withColor:(UIColor *)color {
    CALayer * layer = [self layer];
    layer.borderColor = [color CGColor];
    layer.borderWidth = width;
}

- (void)makeCircle {
    self.layer.cornerRadius = self.frame.size.width / 2;
    self.layer.masksToBounds = YES;
}

- (void)makeCircleWithBorderColor:(UIColor *)color withWidth:(CGFloat)width{
    [self makeCircle];
    [self addBorderWithWidth:width withColor:color];
}

- (void)makeCornorRadius:(CGFloat)radius {
    self.self.layer.cornerRadius = radius;
    self.layer.masksToBounds = YES;
}

@end
