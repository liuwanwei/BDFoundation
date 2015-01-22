//
//  BDViewController.h
//  investigation
//
//  Created by sungeo on 15/1/8.
//  Copyright (c) 2015年 buddysoft. All rights reserved.
//  完善后，放到BDFoundation中

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface BDTableViewController : UITableViewController <MBProgressHUDDelegate>

- (void)makeMoveable;

- (void)startHUDWithMessage:(NSString *)message;
- (void)stopHUDWithSuccessMessage:(NSString *)message;
- (void)stopHUDWithErrorMessage:(NSString *)message;

@end
