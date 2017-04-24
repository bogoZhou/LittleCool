//
//  LooseChangeViewController.m
//  Qian
//
//  Created by 周博 on 17/2/8.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "LooseChangeViewController.h"
#import "BorderHelper.h"
#import "LooseChangeDetailViewController.h"
#import "ChongViewController.h"
#import "TiViewController.h"

@interface LooseChangeViewController ()

@end

@implementation LooseChangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self UISetting];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self UISetting];
}

- (void)UISetting{
    [self navBarbackButton:@"返回"];
    [BorderHelper setBorderWithColor:kColorFrom0x(0x2a7e26) button:_buttonChongZhi];
    [BorderHelper setBorderWithColor:kColorFrom0x(0xe1e1e1) button:_buttonTixian];
//    _buttonChongZhi.layer.borderWidth = 1.f;
    _buttonTixian.layer.borderWidth = 1.f;
    
    [[FMDBHelper fmManger] getFMDBBySQLName:kCreatSQL];
    [[FMDBHelper fmManger] createTableByTableName:kOthreUserTable];
    
    UserInfoModel *model = [[[FMDBHelper fmManger] selectDataByTableName:kOthreUserTable] firstObject];
    
    _labelMoney.text = [NSString stringWithFormat:@"¥%.2lf",model.money.doubleValue];
}

- (void)rightNavButtonClick{
    UIStoryboard *storyboard = kWechatStroyboard;
    LooseChangeDetailViewController *looseChangeDetailVC = [storyboard instantiateViewControllerWithIdentifier:@"LooseChangeDetailViewController"];
    [looseChangeDetailVC navBarTitle:@"零钱明细"];
    [self.navigationController pushViewController:looseChangeDetailVC animated:YES];
}


/**
 充值

 @param sender <#sender description#>
 */
- (IBAction)chongzhiButtonClick:(UIButton *)sender {
    UIStoryboard *storyboard = kWechatStroyboard;
    ChongViewController * chongVC = [storyboard instantiateViewControllerWithIdentifier:@"ChongViewController"];
    [chongVC wechatRightButtonClick:@"完成"];
    [chongVC navBarTitle:@"请编辑零钱金额"];
    [self.navigationController pushViewController:chongVC animated:YES];
}

/**
 提现

 @param sender <#sender description#>
 */
- (IBAction)tixianButtonClick:(UIButton *)sender {
    UIStoryboard *storyboard = kWechatStroyboard;
    TiViewController *tiVC = [storyboard instantiateViewControllerWithIdentifier:@"TiViewController"];
//    [self presentViewController:tiVC animated:YES completion:nil];
    [tiVC navBarTitle:@"零钱提现"];
    [tiVC navBarbackButtonNoLeft:@"取消" textFloat:5];
    [self.navigationController pushViewController:tiVC animated:YES];
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
