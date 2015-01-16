//
//  MoveableTable.m
//  investigation
//
//  Created by sungeo on 15/1/14.
//  Copyright (c) 2015年 buddysoft. All rights reserved.
//

#import "MoveableTableController.h"
#include <objc/message.h>

@interface MoveableTableController()

@property (nonatomic, weak) UITableView * tableView;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPress;

@end

@implementation MoveableTableController

- (id)initWithTableView:(UITableView *)tableView{
    if (self = [super init]) {
        self.tableView = tableView;
        
        [self makeCellMoveable];
    }
    
    return self;
}

// 实现可拖放移动的UITableView
// http://www.raywenderlich.com/63089/cookbook-moving-table-view-cells-with-a-long-press-gesture
// 自己的修改，跟UITableViewDelegate结合：
// 1，支持判断tableView:canMoveRowAtIndexPath:来决定是否支持移动某行
// 2，支持调用tableView:moveRowAtIndexPath:toRowAtIndexPath来修改源数据

- (void)makeCellMoveable{
    if (self.longPress == nil) {
        self.longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognized:)];
        [self.tableView addGestureRecognizer:self.longPress];
    }
}

- (void)makeCellUnMoveable{
    if (self.longPress) {
        [self.tableView removeGestureRecognizer:self.longPress];
    }
}

- (IBAction)longPressGestureRecognized:(id)sender {
    
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState state = longPress.state;
    
    CGPoint location = [longPress locationInView:self.tableView];
    
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
    
    if (self.tableView.delegate && [self.tableView.delegate respondsToSelector:@selector(tableView:canMoveRowAtIndexPath:)]) {
        BOOL ret = (BOOL)[self.tableView.delegate performSelector:@selector(tableView:canMoveRowAtIndexPath:) withObject:indexPath];
        if (!ret) {
            NSLog(@"不能移动该行 %d", (int)indexPath.row);
            indexPath = nil;
        }
    }
    
    static UIView       *sSnapshot = nil;        ///< A snapshot of the row user is moving.
    static NSIndexPath  *sSourceIndexPath = nil; ///< Initial index path, where gesture begins.
    
    switch (state) {
        case UIGestureRecognizerStateBegan: {
            if (indexPath) {
                sSourceIndexPath = indexPath;
                
                UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                
                // Take a snapshot of the selected row using helper method.
                sSnapshot = [self customSnapshoFromView:cell];
                
                // Add the snapshot as subview, centered at cell's center...
                __block CGPoint center = cell.center;
                sSnapshot.center = center;
                sSnapshot.alpha = 0.0;
                [self.tableView addSubview:sSnapshot];
                [UIView animateWithDuration:0.25 animations:^{
                    
                    // Offset for gesture location.
                    center.y = location.y;
                    sSnapshot.center = center;
                    sSnapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
                    sSnapshot.alpha = 0.98;
                    cell.alpha = 0.0;
                    
                } completion:^(BOOL finished) {
                    
                    cell.hidden = YES;
                    
                }];
            }
            break;
        }
            
        case UIGestureRecognizerStateChanged: {
            CGPoint center = sSnapshot.center;
            center.y = location.y;
            sSnapshot.center = center;
            
            // Is destination valid and is it different from source?
            if (indexPath && sSourceIndexPath && ![indexPath isEqual:sSourceIndexPath]) {
                
                // ... move the rows.
                [self.tableView moveRowAtIndexPath:sSourceIndexPath toIndexPath:indexPath];
                
                [self updateDataSourceFromIndexPath:sSourceIndexPath toIndexPath:indexPath];
                
                // ... and update source so it is in sync with UI changes.
                sSourceIndexPath = indexPath;
            }
            break;
        }
            
        default: {
            if (sSourceIndexPath) {
                // Clean up.
                NSLog(@"state %d", (int)state);
                UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:sSourceIndexPath];
                cell.hidden = NO;
                cell.alpha = 0.0;
                
                [UIView animateWithDuration:0.25 animations:^{
                    
                    sSnapshot.center = cell.center;
                    sSnapshot.transform = CGAffineTransformIdentity;
                    sSnapshot.alpha = 0.0;
                    cell.alpha = 1.0;
                    
                } completion:^(BOOL finished) {
                    
                    sSourceIndexPath = nil;
                    [sSnapshot removeFromSuperview];
                    sSnapshot = nil;
                    
                    // 刷新整个界面（假如需要刷新序号的话，否则可以注释掉该行）
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tableView reloadData];
                    });
                }];
            }
            
            break;
        }
    }
}

- (void)updateDataSourceFromIndexPath:(NSIndexPath *)from toIndexPath:(NSIndexPath *)to{
    
    // ... update data source.
    if (self.tableView.delegate && [self.tableView.delegate respondsToSelector:@selector(tableView:moveRowAtIndexPath:toIndexPath:)]) {
        
        // 第一种形式，真机调试有访问越界问题
        //                    objc_msgSend(self.tableView.delegate, sel, self.tableView, sSourceIndexPath, indexPath);
        // 第二种形式，真机调试有访问越界问题
        //                    id (*moveRow)(id, SEL, id, id, id) = (id(*)(id, SEL, id, id, id))objc_msgSend;
        //                    moveRow(self.tableView.delegate, sel, self.tableView,sSourceIndexPath, indexPath);
        
        // 第三种形式：运行良好
        SEL sel = @selector(tableView:moveRowAtIndexPath:toIndexPath:);
        UIViewController * vc = (UIViewController *)self.tableView.delegate;
        NSMethodSignature * sig = [vc methodSignatureForSelector:sel];
        if (sig) {
            NSInvocation * invo = [NSInvocation invocationWithMethodSignature:sig];
            [invo setTarget:self.tableView.delegate];
            [invo setSelector:sel];
            [invo setArgument:&_tableView atIndex:2];
            [invo setArgument:&from atIndex:3];
            [invo setArgument:&to atIndex:4];
            [invo invoke];
        }
    }
    
//#pragma GCC diagnostic push
//#pragma GCC diagnostic ignored "-Wundeclared-selector"
    // 第四种形式，运行良好，但略显麻烦
    //                if (self.tableView.delegate && [self.tableView.delegate respondsToSelector:@selector(moveCellsWithParams:)]) {
    //                    [self.tableView.delegate performSelector:@selector(moveCellsWithParams:)
    //                                                  withObject:@{kTableView:self.tableView,
    //                                                               kSourceIndexPath:sSourceIndexPath,
    //                                                               kTargetIndexPath:indexPath}];
    //                }
//#pragma GCC diagnostic pop
    
    // 刷新交换位置后的两个cells的界面。放置位置不对，而且不如刷新整个TableView，简单方便效果好，
    //                __block NSIndexPath * source = sSourceIndexPath;
    //                __block NSIndexPath * dest = indexPath;
    //                dispatch_async(dispatch_get_main_queue(), ^(){
    //                    [self.tableView reloadRowsAtIndexPaths:@[source, dest] withRowAnimation:UITableViewRowAnimationAutomatic];
    //                });


}

#pragma mark - Helper methods

/** @brief Returns a customized snapshot of a given view. */
- (UIView *)customSnapshoFromView:(UIView *)inputView {
    
    // Make an image from the input view.
    UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, NO, 0);
    [inputView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Create an image view.
    UIView *snapshot = [[UIImageView alloc] initWithImage:image];
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
    
    return snapshot;
}

@end
