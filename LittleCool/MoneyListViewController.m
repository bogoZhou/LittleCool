//
//  MoneyListViewController.m
//  Qian
//
//  Created by 周博 on 17/2/16.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "MoneyListViewController.h"
#import "HcdDateTimePickerView.h"

@interface MoneyListViewController ()<UITextFieldDelegate>
{
    HcdDateTimePickerView * dateTimePickerView;

}
@property (nonatomic,strong) NSString *type;
@end

@implementation MoneyListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self UISetting];
}

- (void)UISetting{
    _textFieldMoney.text = [NSString stringWithFormat:@"%.2lf",_moneyModel.money.doubleValue];
    _textFieldName.text = _moneyModel.name;
    _textFieldDate.text = _moneyModel.date;
    _textFieldMoney.delegate = self;
    _type = _moneyModel.type;
}

- (IBAction)nameButtonClick:(UIButton *)sender {
    [self changeName];
}

- (IBAction)dateButtonClick:(UIButton *)sender {
    [self changeDate];
}

- (void)rightNavButtonClick{
    if ([BGFunctionHelper isNULLOfString:_textFieldMoney.text]) {
        kAlert(@"请输入金额");
        return;
    }
    [[FMDBHelper fmManger] updateDataByTableName:kMoneyTable TypeName:@"money" typeValue0:_textFieldMoney.text typeValue1:@"Id" typeValue2:_moneyModel.Id];
    [[FMDBHelper fmManger] updateDataByTableName:kMoneyTable TypeName:@"name" typeValue0:_textFieldName.text typeValue1:@"Id" typeValue2:_moneyModel.Id];
    [[FMDBHelper fmManger] updateDataByTableName:kMoneyTable TypeName:@"type" typeValue0:_type typeValue1:@"Id" typeValue2:_moneyModel.Id];
    [[FMDBHelper fmManger] updateDataByTableName:kMoneyTable TypeName:@"date" typeValue0:_textFieldDate.text typeValue1:@"Id" typeValue2:_moneyModel.Id];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)changeName{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择转账类型" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *item0 = [UIAlertAction actionWithTitle:@"转账收入" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _type = @"1";
        _textFieldName.text = @"转账收入";
    }];
    UIAlertAction *item1 = [UIAlertAction actionWithTitle:@"转账支出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _type = @"-1";
        _textFieldName.text = @"转账支出";
    }];
    UIAlertAction *item2 = [UIAlertAction actionWithTitle:@"红包收入" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _type = @"1";
        _textFieldName.text = @"红包收入";
    }];
    UIAlertAction *item3 = [UIAlertAction actionWithTitle:@"红包支出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _type = @"-1";
        _textFieldName.text = @"红包支出";
    }];
    UIAlertAction *item4 = [UIAlertAction actionWithTitle:@"提现" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _type = @"-1";
        _textFieldName.text = @"提现";
    }];
    UIAlertAction *item5 = [UIAlertAction actionWithTitle:@"充值" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _type = @"1";
        _textFieldName.text = @"充值";
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        _type = _moneyModel.type;
        _textFieldName.text = _moneyModel.name;
    }];
    
    [alert addAction:item0];
    [alert addAction:item1];
    [alert addAction:item2];
    [alert addAction:item3];
    [alert addAction:item4];
    [alert addAction:item5];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:^{
    }];
}

- (void)changeDate{
    __block MoneyListViewController *weakSelf = self;
    dateTimePickerView = [[HcdDateTimePickerView alloc] initWithDatePickerMode:DatePickerDateHourMinuteMode defaultDateTime:[[NSDate alloc]initWithTimeIntervalSinceNow:1000]];
    dateTimePickerView.clickedOkBtn = ^(NSString * datetimeStr){
        NSLog(@"%@", datetimeStr);
        weakSelf.textFieldDate.text = datetimeStr;
    };
    if (dateTimePickerView) {
        [self.view addSubview:dateTimePickerView];
        [dateTimePickerView showHcdDateTimePicker];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSMutableString * futureString = [NSMutableString stringWithString:textField.text];
    [futureString  insertString:string atIndex:range.location];
    NSInteger flag=0;
    const NSInteger limited = 2;//小数点后需要限制的个数
    for (NSInteger i = futureString.length-1; i>=0; i--) {
        if ([futureString characterAtIndex:i] == '.') {
            if (flag > limited) {
                return NO;
            }
            break;
        }
        flag++;
    }
    return YES;
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
