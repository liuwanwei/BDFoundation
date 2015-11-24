//
//  AertViewTextEditor.m
//  investigation
//
//  Created by sungeo on 14/12/6.
//  Copyright (c) 2014年 buddysoft. All rights reserved.
//

#import "AlertViewTextEditor.h"
#import "BDUtils.h"

@interface AlertViewTextEditor()

@property (nonatomic, copy) NSString * originalText;
@property (nonatomic, strong) TextConfirmed confirmedBlock;
@property (nonatomic, strong) ViewDismissed dismissedBlock;

@end

@implementation AlertViewTextEditor

+ (AlertViewTextEditor *)defaultInstance{
    static AlertViewTextEditor * sEditor = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (sEditor == nil) {
            sEditor = [[AlertViewTextEditor alloc] init];
        }
    });
    
    return sEditor;
}

- (void)showText:(NSString *)text title:(NSString *)title delegate:(id<AlertViewTextEditorDelegate>)delegate{
    self.originalText = text;
    self.title = title;
    self.delegate = delegate;
    
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:title
                                                         message:nil
                                                        delegate:self
                                               cancelButtonTitle:@"取消"
                                               otherButtonTitles:@"确定", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    UITextField * textField = [alertView textFieldAtIndex:0];
    textField.text = text;
    
    [alertView show];
}

- (void)showText:(NSString *)text withTitle:(NSString *)title completed:(TextConfirmed)block{
    self.originalText = text;
    self.title = title;
    self.confirmedBlock = block;
    
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:title
                                                         message:nil
                                                        delegate:self
                                               cancelButtonTitle:@"取消"
                                               otherButtonTitles:@"确定", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    UITextField * textField = [alertView textFieldAtIndex:0];
    textField.text = text;
    
    [alertView show];

}

- (void)showText:(NSString *)text title:(NSString *)title message:(NSString *)message completed:(TextConfirmed)block{
    self.originalText = text;
    self.title = title;
    self.confirmedBlock = block;
    
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:title
                                                         message:message
                                                        delegate:self
                                               cancelButtonTitle:@"取消"
                                               otherButtonTitles:@"确定", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    UITextField * textField = [alertView textFieldAtIndex:0];
    textField.text = text;
    
    [alertView show];
}

- (void)showWithPlaceHolder:(NSString *)text title:(NSString *)title completed:(TextConfirmed)block{
    self.title = title;
    self.confirmedBlock = block;
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:title
                                                         message:nil
                                                        delegate:self
                                               cancelButtonTitle:@"取消"
                                               otherButtonTitles:@"确定", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    UITextField * textField = [alertView textFieldAtIndex:0];
    textField.placeholder = text;
    
    [alertView show];
}

- (void)showWithPlaceHolder:(NSString *)text title:(NSString *)title dismissed:(ViewDismissed)block{
    self.title = title;
    self.dismissedBlock = block;
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:title
                                                         message:nil
                                                        delegate:self
                                               cancelButtonTitle:@"取消"
                                               otherButtonTitles:@"确定", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    UITextField * textField = [alertView textFieldAtIndex:0];
    textField.placeholder = text;
    
    [alertView show];
}

#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == alertView.firstOtherButtonIndex) {
        UITextField * textField = [alertView textFieldAtIndex:0];
        NSString * name = textField.text;
//        if (name.length == 0) {
//            NSString * message = [NSString stringWithFormat:@"%@不能为空", self.title];
//            [Utils alertWithMessage:message];
//            return;
//        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(alertViewTextEditor:didDismissWithText:)]) {
            [self.delegate performSelector:@selector(alertViewTextEditor:didDismissWithText:) withObject:self withObject:name];
        }
        
        if (self.confirmedBlock) {
            self.confirmedBlock(name);
        }
        
        if (self.dismissedBlock) {
            self.dismissedBlock(name, NO);
        }
    }else if(buttonIndex == alertView.cancelButtonIndex){
        if (self.dismissedBlock) {
            self.dismissedBlock(nil, YES);
        }
    }
}

@end
