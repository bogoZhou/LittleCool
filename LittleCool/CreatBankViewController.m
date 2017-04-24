//
//  CreatBankViewController.m
//  Qian
//
//  Created by 周博 on 17/3/6.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "CreatBankViewController.h"

@interface CreatBankViewController ()

@end

@implementation CreatBankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

//完成点击事件
- (void)rightNavButtonClick{
    if ([BGFunctionHelper isNULLOfString:_textFieldBankName.text]) {
        kAlert(@"请输入银行名称");
        return;
    }
    if (_textFieldBankNum.text.length != 4) {
        kAlert(@"请确定输入的是后四位");
        return;
    }
    
    [[FMDBHelper fmManger] createBankTable];
    [[FMDBHelper fmManger] insertBankDataByBankName:_textFieldBankName.text bankNum:_textFieldBankNum.text];
    
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
