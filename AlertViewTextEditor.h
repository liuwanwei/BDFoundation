//
//  AertViewTextEditor.h
//  investigation
//
//  Created by sungeo on 14/12/6.
//  Copyright (c) 2014年 buddysoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^TextConfirmed)(NSString * text);

// 前置声明
@protocol AlertViewTextEditorDelegate;

// Interface
@interface AlertViewTextEditor : NSObject <UIAlertViewDelegate>

@property (nonatomic, copy) NSString * title;
@property (nonatomic, weak) id<AlertViewTextEditorDelegate> delegate;

+ (AlertViewTextEditor *)defaultInstance;

- (void)showText:(NSString *)text title:(NSString *)title delegate:(id<AlertViewTextEditorDelegate>)delegate;
- (void)showText:(NSString *)text withTitle:(NSString *)title completed:(TextConfirmed)block;
- (void)showText:(NSString *)text title:(NSString *)title message:(NSString *)message completed:(TextConfirmed)block;

@end

// Protocol
@protocol AlertViewTextEditorDelegate <NSObject>
@required
- (void)alertViewTextEditor:(AlertViewTextEditor *)editor didDismissWithText:(NSString *)text;
@end
