//
//  SendMoneyViewController.m
//  Qian
//
//  Created by 周博 on 17/2/22.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "SendMoneyViewController.h"
#import "BGDatePickerViewController.h"

@interface SendMoneyViewController ()

@end

@implementation SendMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navBarTitle:@"新增转账"];
    [self navBarbackButton:@"返回"];
    [self wechatRightButtonClick:@"完成"];
}

//转账时间
- (IBAction)sendTimeButtonClick:(UIButton *)sender {
    [self.view endEditing:YES];
    BGDatePickerViewController * picker = [[BGDatePickerViewController alloc] init];
    BGDatePickerAction * action = [BGDatePickerAction actionWithTitle:@"" handler:^(BGDatePickerAction *action) {
        _textFieldSendTime.text = action.titleS;
    }];
    [picker addAction:action];
    [self presentViewController:picker animated:NO completion:nil];
}

//到账时间
- (IBAction)getMoneyButtonClick:(UIButton *)sender {
    [self.view endEditing:YES];
    BGDatePickerViewController * picker = [[BGDatePickerViewController alloc] init];
    BGDatePickerAction * action = [BGDatePickerAction actionWithTitle:@"" handler:^(BGDatePickerAction *action) {
        _textFieldGetTime.text = action.titleS;
    }];
    [picker addAction:action];
    [self presentViewController:picker animated:NO completion:nil];
}

- (void)rightNavButtonClick{
    [self.view endEditing:YES];
    NSDictionary *dict = @{
                           @"money" : _textFieldMoney.text,
                           @"content" : _textFieldContent.text,
                           @"send" : _textFieldSendTime.text,
                           @"get" : _textFieldGetTime.text,
                           @"type" : @"0"
                           };
    [[NSNotificationCenter defaultCenter] postNotificationName:@"sendMoney" object:dict];
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
