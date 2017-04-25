//
//  UserInfoViewController.m
//  Qian
//
//  Created by 周博 on 17/2/7.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "UserInfoViewController.h"
#import "NewUserViewController.h"

@interface UserInfoViewController ()

@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self settingLayout];
    [self UISetting];
    
    NSMutableArray *array = [[FMDBHelper fmManger] selectDataByTableName:kOthreUserTable];
    NSLog(@"%@",array);
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self reSettingUI];
}

- (void)reSettingUI{
    [[FMDBHelper fmManger] getFMDBBySQLName:kCreatSQL];
    [[FMDBHelper fmManger] createTableByTableName:kOthreUserTable];
    UserInfoModel *model = [[UserInfoModel alloc] init];
    
    model = [[[FMDBHelper fmManger] selectDataByTableName:kOthreUserTable] firstObject];
    _imageViewHeader.image = [UIImage imageWithData:model.headImage];
    _imageViewHeader.layer.masksToBounds = YES;
    _imageViewHeader.layer.cornerRadius = kButtonCornerRadius;
    _imageViewHeader.layer.borderColor = [kd2d2d2 CGColor];
    _imageViewHeader.layer.borderWidth = 0.5f;
    
    _labelNickName.text = model.name;
    _labelWechatNum.text = model.wechatNum;
}

- (void)settingLayout{
    _layoutHeight.constant = kScreenSize.height - 64;
    _layoutWidth.constant = kScreenSize.width;
}

- (void)UISetting{
    _imageViewHeader.backgroundColor = kClearColor;
    [self navBarTitle:@"设置"];
    [self navBarbackButton:@"我"];
    [self wechatRightButtonClick:@"新建账户"];
}

- (IBAction)buttonClick:(UIButton *)sender {
    UIStoryboard * storyboard = kWechatStroyboard;
    NewUserViewController * newUserVC = [storyboard instantiateViewControllerWithIdentifier:@"NewUserViewController"];
    [newUserVC navBarTitle:@"编辑"];
    newUserVC.willChange = @"1";
    [newUserVC navBarbackButton:@"设置"];
    [self.navigationController pushViewController:newUserVC animated:YES];
}

- (void)rightNavButtonClick{
    UIStoryboard * storyboard = kWechatStroyboard;
    NewUserViewController * newUserVC = [storyboard instantiateViewControllerWithIdentifier:@"NewUserViewController"];
    [newUserVC navBarTitle:@"新建用户"];
    newUserVC.willChange = @"-1";
    [newUserVC navBarbackButton:@"设置"];
    [self.navigationController pushViewController:newUserVC animated:YES];
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
