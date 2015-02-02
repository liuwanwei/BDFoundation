//
//  BDViewController.m
//  investigation
//
//  Created by sungeo on 15/1/8.
//  Copyright (c) 2015年 buddysoft. All rights reserved.
//

#import "BDTableViewController.h"
#import "MBProgressHUD.h"
#import "MoveableTableController.h"

@interface BDTableViewController ()

@property (nonatomic, strong) MBProgressHUD * HUD;
@property (nonatomic, strong) MoveableTableController * moveableController;

@end

@implementation BDTableViewController

- (id)initWithStyle:(UITableViewStyle)style{
    return [super initWithStyle:style];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.clearsSelectionOnViewWillAppear = YES;
}

- (void)makeMoveable{
    self.moveableController = [[MoveableTableController alloc] initWithTableView:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startHUDWithMessage:(NSString *)message{
    self.HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    self.HUD.delegate = self;
}

- (void)startHUDWithUploadMessage{
    [self startHUDWithMessage:@"上传中"];
}

- (void)stopHUDWithSuccessMessage:(NSString *)message{
    self.HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
    self.HUD.mode = MBProgressHUDModeCustomView;
    self.HUD.labelText = message;
    [self.HUD hide:YES afterDelay:1];
}

- (void)stopHUDWithSuccessUploadMessage{
    [self stopHUDWithSuccessMessage:@"上传成功"];
}

- (void)stopHUDWithErrorMessage:(NSString *)message{
    self.HUD.mode = MBProgressHUDModeText;
    self.HUD.labelText = message;
    self.HUD.margin = 10.f;
    self.HUD.removeFromSuperViewOnHide = YES;
    [self.HUD hide:YES afterDelay:1.5f];

}

- (void)stopHUDWithErrorUploadMessage{
    [self stopHUDWithErrorMessage:@"上传失败"];
}

- (void)stopHUD{
    [self.HUD hide:YES];
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
