//
//  ChongViewController.m
//  Qian
//
//  Created by 周博 on 17/2/9.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "ChongViewController.h"

@interface ChongViewController ()

@end

@implementation ChongViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navBarbackButton:@""];
}


//点击完场保存
- (void)rightNavButtonClick{
    
    NSString *moneyText = [NSString stringWithFormat:@"%.2lf",_textFieldMoney.text.doubleValue];
    
    [[FMDBHelper fmManger] getFMDBBySQLName:kCreatSQL];
    [[FMDBHelper fmManger] createTableByTableName:kOthreUserTable];
    [[FMDBHelper fmManger] updateDataByTableName:kOthreUserTable TypeName:@"money" typeValue0:moneyText typeValue1:@"Id" typeValue2:@"1"];
    
    [self.navigationController popViewControllerAnimated:YES];
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
