//
//  MoveableTable.h
//  investigation
//
//  Created by sungeo on 15/1/14.
//  Copyright (c) 2015年 buddysoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define kSourceIndexPath        @"sourceIndexPath"
#define kTargetIndexPath        @"targetIndexPath"
#define kTableView              @"tableView"

@interface MoveableTableController : NSObject

- (void)makeCellMoveable;
- (void)makeCellUnMoveable;

- (id)initWithTableView:(UITableView *)tableView;

@end
