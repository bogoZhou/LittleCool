//
//  RedPacketViewController.m
//  Qian
//
//  Created by 周博 on 17/2/21.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "RedPacketViewController.h"
#import "BGDatePickerViewController.h"

@interface RedPacketViewController ()

@end

@implementation RedPacketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)rightNavButtonClick{
    [self.view endEditing:YES];
    
    //创建红包表
    [[FMDBHelper fmManger] createRedPacketTable];
    [[FMDBHelper fmManger] insertRedPacketByRedMoney:_textFieldMoney.text redSurplusMoney:_textFieldMoney.text redNum:_textFieldPersonNum.text redSurplusNum:_textFieldPersonNum.text creatDate:[self countDate:_textFieldSendTime.text] endDate:[self countDate:_textFieldEndTime.text] redContent:_textFieldContent.text];
    
    ChatRedPacketModel *model = [[[FMDBHelper fmManger] selectRedPacketWhereValue1:@"" value2:@"" isNeed:NO] lastObject];
    
//    NSDictionary *dict = @{
//                           @"money" : _textFieldMoney.text,
//                           @"content" : _textFieldContent.text
//                           };
    [[NSNotificationCenter defaultCenter] postNotificationName:@"redPacket" object:model.Id];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 点击事件
//选择发送时间
- (IBAction)sendTimeButtonClick:(UIButton *)sender {
    [self.view endEditing:YES];
    BGDatePickerViewController * picker = [[BGDatePickerViewController alloc] init];
    BGDatePickerAction * action = [BGDatePickerAction actionWithTitle:@"" handler:^(BGDatePickerAction *action) {
        _textFieldSendTime.text = action.titleS;
    }];
    [picker addAction:action];
    [self presentViewController:picker animated:NO completion:nil];
}

//选择领完时间
- (IBAction)endTimeButtonClick:(UIButton *)sender {
    [self.view endEditing:YES];
    BGDatePickerViewController * picker = [[BGDatePickerViewController alloc] init];
    BGDatePickerAction * action = [BGDatePickerAction actionWithTitle:@"" handler:^(BGDatePickerAction *action) {
        _textFieldEndTime.text = action.titleS;
    }];
    [picker addAction:action];
    [self presentViewController:picker animated:NO completion:nil];
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
