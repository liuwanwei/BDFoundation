//
//  TextEditViewController.m
//  investigation
//
//  Created by sungeo on 14/12/3.
//  Copyright (c) 2014年 buddysoft. All rights reserved.
//

#import "TextEditViewController.h"

@interface TextEditViewController ()

@property (nonatomic, copy) NSString * theOriginalText;
@property (nonatomic, strong) UITextField * textField;
@property (nonatomic, strong) UITextView * textView;

@end

@implementation TextEditViewController

- (void)setOriginalText:(NSString *)text{
    self.theOriginalText = text;
}

- (void)initSingleLineTextEditor{
    UITextField * textField = [[UITextField alloc] init];
    textField.font = [UIFont systemFontOfSize:17.0];
    textField.layer.borderColor = [[UIColor colorWithWhite:.8 alpha:1.0] CGColor];
    textField.layer.borderWidth = 0.65f;
    textField.layer.cornerRadius = 6.0f;
    textField.keyboardType = self.keyboardType == 0 ? UIKeyboardTypeDefault: self.keyboardType;
    [self.view addSubview:textField];
    self.textField = textField;
    
    // 留出左右5points宽的空间，比subclass UITextField的方法简单多了！
    UIView * spaceView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.leftView = spaceView;
    textField.rightViewMode = UITextFieldViewModeAlways;
    textField.rightView = spaceView;
    
    // 设置位置
    textField.translatesAutoresizingMaskIntoConstraints = NO;
    NSMutableArray * constraints = [[NSMutableArray alloc] init];
    
    // left = super.left + n
    [constraints addObject:[NSLayoutConstraint constraintWithItem:textField
                                                        attribute:NSLayoutAttributeLeft
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.view
                                                        attribute:NSLayoutAttributeLeft
                                                       multiplier:1.0
                                                         constant:5.0]];
    // right = super.right - n
    [constraints addObject:[NSLayoutConstraint constraintWithItem:textField
                                                        attribute:NSLayoutAttributeRight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.view
                                                        attribute:NSLayoutAttributeRight
                                                       multiplier:1.0
                                                         constant:-5.0]];
    // top = super.top - n;
    [constraints addObject:[NSLayoutConstraint constraintWithItem:textField
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.view
                                                        attribute:NSLayoutAttributeTop
                                                       multiplier:1.0
                                                         constant:70.0]];
    // height = n;
    [constraints addObject:[NSLayoutConstraint constraintWithItem:textField
                                                        attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:nil
                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                       multiplier:1.0
                                                         constant:44.0]];
    [self.view addConstraints:constraints];
    
    
    textField.text = self.theOriginalText;
}

// 多行文本输入
- (void)initMultiLineTextEditor{
    UITextView * textField = [[UITextView alloc] init];
    textField.font = [UIFont systemFontOfSize:17.0];
    textField.layer.borderColor = [[UIColor colorWithWhite:.8 alpha:1.0] CGColor];
    textField.layer.borderWidth = 0.65f;
    textField.layer.cornerRadius = 6.0f;
    textField.keyboardType = self.keyboardType == 0 ? UIKeyboardTypeDefault: self.keyboardType;
    [self.view addSubview:textField];
    self.textView = textField;
    
    textField.editable = YES;
    textField.dataDetectorTypes = UIDataDetectorTypeAll;
    textField.contentInset = UIEdgeInsetsMake(-7.0, 0, 0, 0);
    
    // 设置位置
    textField.translatesAutoresizingMaskIntoConstraints = NO;
    NSMutableArray * constraints = [[NSMutableArray alloc] init];
    
    // left = super.left + n
    [constraints addObject:[NSLayoutConstraint constraintWithItem:textField
                                                        attribute:NSLayoutAttributeLeft
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.view
                                                        attribute:NSLayoutAttributeLeft
                                                       multiplier:1.0
                                                         constant:5.0]];
    // right = super.right - n
    [constraints addObject:[NSLayoutConstraint constraintWithItem:textField
                                                        attribute:NSLayoutAttributeRight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.view
                                                        attribute:NSLayoutAttributeRight
                                                       multiplier:1.0
                                                         constant:-5.0]];
    // top = super.top - n - StatusBarHeight - NavigationBarHeight;
    // TODO: 检测当前是否存在导航栏和状态栏，从而更精确的控制顶部起始位置
    [constraints addObject:[NSLayoutConstraint constraintWithItem:textField
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.view
                                                        attribute:NSLayoutAttributeTop
                                                       multiplier:1.0
                                                         constant:70]];
    // height = n;
    [constraints addObject:[NSLayoutConstraint constraintWithItem:textField
                                                        attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:nil
                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                       multiplier:1.0
                                                         constant:132.0]];
    [self.view addConstraints:constraints];
    
    
    textField.text = self.theOriginalText;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.title.length == 0 ? @"编辑" : self.title;
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (self.type == TextEditorTypeSingleLine) {
        [self initSingleLineTextEditor];
    }else{
        [self initMultiLineTextEditor];
    }
    
}

- (BOOL)automaticallyAdjustsScrollViewInsets{
    return NO;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (self.type == TextEditorTypeSingleLine) {
        [self.textField becomeFirstResponder];
    }else{
        [self.textView becomeFirstResponder];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    NSString * text;
    if (self.type == TextEditorTypeSingleLine) {
        [self.textField resignFirstResponder];
        text = self.textField.text;
    }else{
        [self.textView resignFirstResponder];
        text = self.textView.text;
    }
    
    NSDictionary * userInfo = @{kTextResult:text};
    if (self.identifier.length != 0) {
        NSMutableDictionary * mutable = [NSMutableDictionary dictionaryWithDictionary:userInfo];
        mutable[kTextIdentifier] = self.identifier;
        userInfo = mutable;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kTextEditedMessage object:self userInfo:userInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
