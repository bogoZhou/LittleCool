//
//  WechatPayChangeViewController.m
//  Qian
//
//  Created by 周博 on 17/3/11.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "WechatPayChangeViewController.h"
#import "HcdDateTimePickerView.h"


@interface WechatPayChangeViewController ()
{
    HcdDateTimePickerView * dateTimePickerView;

}
@property (nonatomic,strong) WechatPayModel *model;
@property (nonatomic,strong) UIView *line1View;
@property (nonatomic,strong) UIView *contentView;
@end

@implementation WechatPayChangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navBarTitle:@"信息编辑"];
    [self navBarbackButton:@"返回"];
    [self wechatRightButtonClick:@"完成"];
    
    [self firstStept];
}

- (void)firstStept{
    _model = [[[FMDBHelper fmManger] selectWechatPayUserWhereValue1:@"Id" value2:_payId isNeed:YES] lastObject];
    [self creatUIByModel:_model];
}

//type = 1 -> 零钱提现发起 ; type = 2 -> 零钱提现到账 ; type = 3 -> 红包退还通知 ; type = 4 -> 转账过期退换通知
- (void)creatUIByModel:(WechatPayModel *)model{
    _model = model;
    UIImageView *deepLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, _line1View.sizeHeight-0.5, kScreenSize.width, 0.5)];
    if (!_line1View) {
        _line1View = [[UIView alloc] initWithFrame:CGRectMake(0, 15, kScreenSize.width, 50)];
        _line1View.backgroundColor = kWhiteColor;
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 150, 20)];
        label1.text = @"类型选择";
        
        [_line1View addSubview:label1];
        
        UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(kScreenSize.width - 200, 15, 185, 20)];
        NSString *typeString ;
        if (model.type.integerValue == 1) {
            typeString = @"零钱提现发起";
        }else if (model.type.integerValue == 2){
            typeString = @"零钱提现到账";
        }else if (model.type.integerValue == 3){
            typeString = @"转账过期退还通知";
        }else if (model.type.integerValue == 4){
            typeString = @"红包退还通知";
        }
        
        [button1 setTitle:typeString forState:UIControlStateNormal];
        [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        button1.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        [button1 addTarget:self action:@selector(chooseType:) forControlEvents:UIControlEventTouchUpInside];
        [_line1View addSubview:button1];
        
        deepLine.backgroundColor = kColorFrom0x(0xd9d9d9);
        [_line1View addSubview:deepLine];
    }

    //这里创建其余所有的View
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, _line1View.allHeight, kScreenSize.width, 300)];
    
    //金额
    UIView *line2View = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, 50)];
    line2View.backgroundColor = kWhiteColor;
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 150, 20)];
    if (model.type.integerValue <= 2) {
        label2.text = @"提现金额";
    }else if (model.type.integerValue == 3){
        label2.text = @"转账金额";
    }
    
    [line2View addSubview:label2];
    
    UITextField *textFieldMoney = [[UITextField alloc] initWithFrame:CGRectMake(kScreenSize.width - 200, 10, 185, 30)];
    textFieldMoney.borderStyle = UITextBorderStyleNone;
    textFieldMoney.keyboardType = UIKeyboardTypeNumberPad;
    textFieldMoney.font = [UIFont systemFontOfSize:16];
    textFieldMoney.clearButtonMode = UITextFieldViewModeWhileEditing;
    textFieldMoney.placeholder = @"请输入金额";
    textFieldMoney.text = [NSString stringWithFormat:@"%.2lf",model.money.doubleValue];
    textFieldMoney.textAlignment = NSTextAlignmentRight;
    [textFieldMoney addTarget:self action:@selector(textFieldMoneyChanged:) forControlEvents:UIControlEventEditingChanged];
    deepLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, _line1View.sizeHeight-0.5, kScreenSize.width, 0.5)];
    deepLine.backgroundColor = kColorFrom0x(0xd9d9d9);
    [line2View addSubview:deepLine];
    [line2View addSubview:textFieldMoney];
    
    [_contentView addSubview:line2View];
    
    //昵称/银行卡号
    UIView *line3View = [[UIView alloc] initWithFrame:CGRectMake(0, 50, kScreenSize.width, 50)];
    line3View.backgroundColor = kWhiteColor;
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 150, 20)];
    if (model.type.integerValue <= 2) {
        label3.text = @"银行卡尾号";
    }else if (model.type.integerValue == 3){
        label3.text = @"对方昵称";
    }
    
    [line3View addSubview:label3];
    
    UITextField *textFieldName = [[UITextField alloc] initWithFrame:CGRectMake(kScreenSize.width - 200, 10, 185, 30)];
    textFieldName.borderStyle = UITextBorderStyleNone;
    textFieldName.font = [UIFont systemFontOfSize:16];
    textFieldName.text = model.userName;
    textFieldName.textAlignment = NSTextAlignmentRight;
    if (model.type.integerValue <= 2) {
        textFieldName.keyboardType = UIKeyboardTypeNumberPad;
        textFieldName.placeholder = @"请输入银行卡后四位";
    }else if (model.type.integerValue == 3){
        textFieldName.keyboardType = UIKeyboardTypeDefault;
        textFieldName.placeholder = @"请输入对方昵称";
    }
    [textFieldName addTarget:self action:@selector(textFieldNameChanged:) forControlEvents:UIControlEventEditingChanged];
    deepLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, _line1View.sizeHeight-0.5, kScreenSize.width, 0.5)];
    deepLine.backgroundColor = kColorFrom0x(0xd9d9d9);
    [line3View addSubview:deepLine];
    [line3View addSubview:textFieldName];
    
    [_contentView addSubview:line3View];
    
    //设置model中的时间

    _model.startDate =[BGDateHelper getTimeArrayByTimeString:model.startDate][6];
    _model.endDate = [BGDateHelper getTimeArrayByTimeString:model.endDate][6];
    
    //提现时间
    UIView *line4View = [[UIView alloc] initWithFrame:CGRectMake(0, 100, kScreenSize.width, 50)];
    line4View.backgroundColor = kWhiteColor;
    UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 150, 20)];
    label4.text = @"提现时间";
    
    [line4View addSubview:label4];
    
    UIButton *startDateButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenSize.width - 200, 15, 185, 20)];
    [startDateButton setTitle:model.startDate forState:UIControlStateNormal];
    startDateButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [startDateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    startDateButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    startDateButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    startDateButton.tag = 1001;
    [startDateButton addTarget:self action:@selector(startDateButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    deepLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, _line1View.sizeHeight-0.5, kScreenSize.width, 0.5)];
    deepLine.backgroundColor = kColorFrom0x(0xd9d9d9);
    [line4View addSubview:deepLine];
    [line4View addSubview:startDateButton];
    
    [_contentView addSubview:line4View];
    
    //到账时间
    UIView *line5View = [[UIView alloc] initWithFrame:CGRectMake(0, 150, kScreenSize.width, 50)];
    line5View.backgroundColor = kWhiteColor;
    UILabel *label5 = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 150, 20)];

    label5.text = @"到账时间";
    
    [line5View addSubview:label5];
    
    UIButton *endDateButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenSize.width - 200, 15, 185, 20)];
    
    deepLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, _line1View.sizeHeight-0.5, kScreenSize.width, 0.5)];
    deepLine.backgroundColor = kColorFrom0x(0xd9d9d9);
    [line5View addSubview:deepLine];

    [endDateButton setTitle:model.endDate forState:UIControlStateNormal];
    endDateButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [endDateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    endDateButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    endDateButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    endDateButton.tag = 1002;
    [endDateButton addTarget:self action:@selector(startDateButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [line5View addSubview:endDateButton];

    [_contentView addSubview:line5View];
    
    if (model.type.integerValue <= 2) {
        //提现银行
        UIView *line6View = [[UIView alloc] initWithFrame:CGRectMake(0, 200, kScreenSize.width, 50)];
        line6View.backgroundColor = kWhiteColor;
        UILabel *label6 = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 150, 20)];
        
        label6.text = @"提现银行";
        
        [line6View addSubview:label6];
        
        UITextField *textFieldBank = [[UITextField alloc] initWithFrame:CGRectMake(kScreenSize.width - 200, 10, 185, 30)];
        
        deepLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, _line1View.sizeHeight-0.5, kScreenSize.width, 0.5)];
        deepLine.backgroundColor = kColorFrom0x(0xd9d9d9);
//        [line6View addSubview:deepLine];
        textFieldBank.borderStyle = UITextBorderStyleNone;
        textFieldBank.font = [UIFont systemFontOfSize:16];
        textFieldBank.text = model.remark;
        textFieldBank.textAlignment = NSTextAlignmentRight;
        textFieldBank.keyboardType = UIKeyboardTypeDefault;
        textFieldBank.placeholder = @"请输入转账银行";
        [textFieldBank addTarget:self action:@selector(textFieldBankNameChanged:) forControlEvents:UIControlEventEditingChanged];
        [line6View addSubview:textFieldBank];
        
        [_contentView addSubview:line6View];
    }
    
    
    [self.view addSubview:_line1View];
    [self.view addSubview:_contentView];
}

#pragma mark - 点击事件
//点击完成
- (void)rightNavButtonClick{
    [self.view endEditing:YES];
    [[FMDBHelper fmManger] updateDataByTableName:kWechatPayTable TypeName:@"type" typeValue0:_model.type typeValue1:@"Id" typeValue2:_model.Id];
    [[FMDBHelper fmManger] updateDataByTableName:kWechatPayTable TypeName:@"money" typeValue0:_model.money typeValue1:@"Id" typeValue2:_model.Id];
    [[FMDBHelper fmManger] updateDataByTableName:kWechatPayTable TypeName:@"startDate" typeValue0:[BGDateHelper getTimeStempByString:_model.startDate havehh:YES] typeValue1:@"Id" typeValue2:_model.Id];
    [[FMDBHelper fmManger] updateDataByTableName:kWechatPayTable TypeName:@"endDate" typeValue0:[BGDateHelper getTimeStempByString:_model.endDate havehh:YES] typeValue1:@"Id" typeValue2:_model.Id];
    [[FMDBHelper fmManger] updateDataByTableName:kWechatPayTable TypeName:@"userName" typeValue0:_model.userName typeValue1:@"Id" typeValue2:_model.Id];
    [[FMDBHelper fmManger] updateDataByTableName:kWechatPayTable TypeName:@"remark" typeValue0:_model.remark typeValue1:@"Id" typeValue2:_model.Id];
    [self.navigationController popViewControllerAnimated:YES];
}

//选择类型
- (void)chooseType:(UIButton *)button{
    [self.view endEditing:YES];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择类型" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"零钱提现发起" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [_contentView removeFromSuperview];
        _model.type = @"1";
        [button setTitle:@"零钱提现发起" forState:UIControlStateNormal];
        [self creatUIByModel:_model];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"零钱提现到账" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [_contentView removeFromSuperview];
        _model.type = @"2";
        [button setTitle:@"零钱提现到账" forState:UIControlStateNormal];
        [self creatUIByModel:_model];
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"转账过期退还通知" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [_contentView removeFromSuperview];
        _model.type = @"3";
        [button setTitle:@"转账过期退还通知" forState:UIControlStateNormal];
        [self creatUIByModel:_model];
    }];
    UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:action1];
    [alert addAction:action2];
    [alert addAction:action3];
    [alert addAction:action4];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)textFieldNameChanged:(UITextField *)textField{
    _model.userName = textField.text;
}

- (void)textFieldMoneyChanged:(UITextField *)textField{
    _model.money = [NSString stringWithFormat:@"%.2lf",textField.text.doubleValue];
}

- (void)textFieldBankNameChanged:(UITextField *)textField{
    _model.remark = textField.text;
}

//选择开始时间
- (void)startDateButtonClick:(UIButton *)button{
    __block WechatPayChangeViewController *weakSelf = self;
    [self.view endEditing:YES];
    dateTimePickerView = [[HcdDateTimePickerView alloc] initWithDatePickerMode:DatePickerDateHourMinuteMode defaultDateTime:[[NSDate alloc]initWithTimeIntervalSinceNow:1000]];
    dateTimePickerView.clickedOkBtn = ^(NSString * datetimeStr){
        NSLog(@"%@", datetimeStr);
        if (button.tag == 1001) {
            weakSelf.model.startDate = datetimeStr;
        }else{
            weakSelf.model.endDate = datetimeStr;
        }
        [button setTitle:datetimeStr forState:UIControlStateNormal];
    };
    if (dateTimePickerView) {
        [self.view addSubview:dateTimePickerView];
        [dateTimePickerView showHcdDateTimePicker];
    }
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
