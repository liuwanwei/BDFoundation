//
//  UIView+Additional.m
//  elap
//
//  Created by maoyu on 15/6/19.
//  Copyright (c) 2015年 maoyu. All rights reserved.
//

#import "UIView+Additional.h"

@implementation UIView (Additional)

- (void)makeCornorRadius:(CGFloat)radius {
    self.layer.cornerRadius = radius;
    self.layer.masksToBounds = YES;
}

- (void)makeCircle {
    self.layer.cornerRadius = self.frame.size.width / 2;
    self.layer.masksToBounds = YES;
}

- (void)addBorderWithWidth:(NSInteger)width withColor:(UIColor *)color {
    CALayer * layer = [self layer];
    layer.borderColor = [color CGColor];
    layer.borderWidth = width;
}

- (void)addAction:(SEL)action target:(id)target {
    UITapGestureRecognizer * singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    [singleTap setNumberOfTapsRequired:1];
    [self setUserInteractionEnabled:YES];
    [self addGestureRecognizer:singleTap];
}
@end
