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

@end
