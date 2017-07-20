//
//  TiViewController.m
//  Qian
//
//  Created by 周博 on 17/2/9.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "TiViewController.h"
#import "BorderHelper.h"
#import "PayViewController.h"
#import "TiDetailViewController.h"
#import "BankCarkViewController.h"
#import "BGTextView.h"

@interface TiViewController ()<UITextViewDelegate>
{
    NSString *_moneyStr;
    NSString *_isJump;
    NSString *_bankName;
    NSString *_bankNum;
    NSString *_copyMoneyStr;
}
@property (strong, nonatomic) BGTextView *textView;
@property (nonatomic,strong) UIButton *rightBTN;
@end

@implementation TiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self UISetting];
    _buttonTixian.alpha = 0.5;
    _buttonTixian.enabled = NO;
    _isJump = @"0";
    [self navBarRButton];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backback) name:@"backback" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bank:) name:@"bank" object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_textView becomeFirstResponder];
}

- (void)backback{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)bank:(NSNotification *)noti{
    BankCardModel *bank = noti.object;
    _labelBank.text = [NSString stringWithFormat:@"%@ (%@)",bank.bankName,bank.bankNum];
    _labelBankRate.text = [NSString stringWithFormat:@"提现到%@，手续费率0.1%@",bank.bankName,@"%"];
    _bankName = bank.bankName;
    _bankNum = bank.bankNum;
//    [[NSUserDefaults standardUserDefaults] setObject:bank forKey:@"bank"];
    [[NSUserDefaults standardUserDefaults] setValue:bank.bankName forKey:@"bankName"];
    [[NSUserDefaults standardUserDefaults] setValue:bank.bankNum forKey:@"bankNum"];
}

- (void)navBarRButton{
    _rightBTN = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightBTN setFrame:CGRectMake(0, 0, 20, 20)];
    [_rightBTN setImage:[UIImage imageNamed:@"wenhao.png"] forState:UIControlStateNormal];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc] initWithCustomView:_rightBTN];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = 0;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, rightItem, nil];
    
}

- (void)UISetting{
    
    _bankName = @"工商银行";
    _bankNum = @"9088";
    
    NSString *bank = [[NSUserDefaults standardUserDefaults] valueForKey:@"bankName"];
    if (bank) {
        _bankName = [[NSUserDefaults standardUserDefaults] valueForKey:@"bankName"];
        _bankNum = [[NSUserDefaults standardUserDefaults] valueForKey:@"bankNum"];
        _labelBank.text = [NSString stringWithFormat:@"%@ (%@)",_bankName,_bankNum];
        _labelBankRate.text = [NSString stringWithFormat:@"提现到%@，手续费率0.1%@",_bankName,@"%"];
        
        
    }
    
    _viewBankCard.layer.cornerRadius = 2;
    [BorderHelper setBorderWithColor:kColorFrom0x(0x2a7e26) button:_buttonTixian];
    
    _textView = [[BGTextView alloc] initWithFrame:self.viewTextView.bounds];
    _textView.textFont = [UIFont fontWithName:kWechatNumFont size:50];
    _textView.placeholderStr = @"";
    _textView.textViewTextColor = [UIColor blackColor];
    
    _textView.tintColor = kWechatBlack;
    _textView.keyboardType = UIKeyboardTypeNumberPad;
    [_textView updateInfo];
    _textView.delegate = self;
    [_viewTextView addSubview:_textView];
    
    [[FMDBHelper fmManger] getFMDBBySQLName:kCreatSQL];
    [[FMDBHelper fmManger] createTableByTableName:kOthreUserTable];
    UserInfoModel *model = [[[FMDBHelper fmManger] selectDataByTableName:kOthreUserTable] firstObject];
    _moneyStr = model.money;
    
    
    _labelAllMoney.text = [NSString stringWithFormat:@"零钱余额¥%.2lf,",_moneyStr.doubleValue];
}

/**
 设置状态栏颜色

 @return <#return value description#>
 */
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)toggle:(id)sender {
    if ([self.textView isFirstResponder]) {
        [self.textView resignFirstResponder];
    } else {
        [self.textView becomeFirstResponder];
    }
}

#pragma mark - 点击事件
//取消
- (IBAction)cancelButtonClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//选择银行卡
- (IBAction)changeBankCard:(UIButton *)sender {
    UIStoryboard *storyboard = kWechatStroyboard;
    BankCarkViewController *bankCardVC = [storyboard instantiateViewControllerWithIdentifier:@"BankCarkViewController"];
    [bankCardVC navBarTitle:@"选择银行卡"];
    [self.navigationController pushViewController:bankCardVC animated:YES];
//    [self presentViewController:bankCardVC animated:YES completion:nil];
}

//选定所有钱
- (IBAction)allMoneyButtonClick:(UIButton *)sender {
    [self.textView setText:_moneyStr];
    if (_moneyStr.doubleValue > 0) {
        _buttonTixian.alpha = 1;
        _buttonTixian.enabled = YES;
    }
}

//提现按钮
- (IBAction)tixianButtonClick:(UIButton *)sender {
    [_textView resignFirstResponder];
    NSString *moneyText = [NSString stringWithFormat:@"%.2lf",_moneyStr.doubleValue - _textView.text.doubleValue];
    
    [[FMDBHelper fmManger] updateDataByTableName:kOthreUserTable TypeName:@"money" typeValue0:moneyText typeValue1:@"Id" typeValue2:@"1"];
    PayViewController *payVC = [[PayViewController alloc] init];
    
    payVC.bankString = _bankName;
    payVC.bankNumString = _bankNum;
    payVC.moneyString = _textView.text;
    [self presentViewController:payVC animated:YES completion:nil];
//    [self.navigationController pushViewController:payVC animated:YES];
}

//到账时间
- (IBAction)timeButtonClick:(UIButton *)sender {
    
}

- (void)textViewDidChange:(UITextView *)textView{
    double tiMoney = [textView.text doubleValue];
    double haveMoney = [_moneyStr doubleValue];
    _labelAllCash.hidden = YES;
    if (tiMoney > haveMoney && tiMoney >= 0) {
        _labelAllMoney.text = @"输入金额超过零钱余额";
        _labelAllMoney.textColor = kRedColor;
        _buttonTixian.alpha = 0.5;
        _buttonTixian.enabled = NO;
    }else{
        //        _labelAllCash.hidden = YES;
        _labelAllMoney.textColor = kColorFrom0x(0x878787);
        //        _labelAllMoney.text = [NSString stringWithFormat:@"%.2lf,",_moneyStr.doubleValue];
        CGFloat rate =tiMoney * 0.001;
        _labelAllMoney.text = [NSString stringWithFormat:@"额外扣除¥%.2lf手续费",rate > 0.10 ? rate : 0.1];
        _buttonTixian.alpha = 1;
        _buttonTixian.enabled = YES;
    }
    if (tiMoney == 0) {
        _labelAllMoney.textColor = kColorFrom0x(0x878787);
        _labelAllMoney.text = [NSString stringWithFormat:@"零钱余额¥%.2lf,",_moneyStr.doubleValue];
        _labelAllCash.hidden = NO;
    }

    //判断每行输入数量
    if (textView.text.integerValue > 9999999.99) {
        textView.text = _copyMoneyStr;
        return;
    }
    
    _copyMoneyStr = textView.text;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSMutableString * futureString = [NSMutableString stringWithString:textView.text];
    [futureString  insertString:text atIndex:range.location];
    NSInteger flag=0;
    NSInteger limited ;//小数点后需要限制的个数
    
    if (text.integerValue > 999999.99) {
        limited = 1;
    }else{
        limited = 2;
    }
    
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
