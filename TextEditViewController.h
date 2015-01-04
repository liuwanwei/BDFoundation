//
//  TextEditViewController.h
//  investigation
//
//  Created by sungeo on 14/12/3.
//  Copyright (c) 2014年 buddysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    TextEditorTypeSingleLine,           // 单行文本
    TextEditorTypeMultiLine             // 多行文本
}TextEditorType;

#define kTextEditedMessage              @"TextEdited"
#define kTextResult                     @"TextResult"
#define kTextIdentifier                 @"TextIdentifier"

#define TextFromNotification(n)         n.userInfo[kTextResult]
#define IdentifierFromNotification(n)   n.userInfo[kTextIdentifier]

@interface TextEditViewController : UIViewController

@property (nonatomic) TextEditorType type;

/*
 * 文本输入框模式下使用的键盘类型
 */
@property (nonatomic) UIKeyboardType keyboardType;

/*
 * 用来区分要编辑的文本类型，调用者设置，会在 NSNotification.userInfo[kTextIdentifier]中，
 * 返回给调用者。
 */
@property (nonatomic, strong) NSString * identifier;


/*
 * 设置要编辑的文本内容
 */
- (void)setOriginalText:(NSString *)text;


@end
