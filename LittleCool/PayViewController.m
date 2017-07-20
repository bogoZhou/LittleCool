//
//  PayViewController.m
//  Qian
//
//  Created by 周博 on 17/3/5.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "PayViewController.h"
#import "PZXVerificationCodeView.h"
#import "TiDetailViewController.h"

@interface PayViewController ()
{
    
}
@property(nonatomic,strong)PZXVerificationCodeView *pzxView;
@property(nonatomic,strong)UITextField *TF;
@property (nonatomic,strong) UIView *payView;
@end

@implementation PayViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self creatPayView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(successFun) name:@"close" object:nil];
}

- (void)successFun{    
    UIStoryboard *storyboard = kWechatStroyboard;
    TiDetailViewController *tiDetailVC = [storyboard instantiateViewControllerWithIdentifier:@"TiDetailViewController"];
    
    tiDetailVC.dateString = [BGDateHelper seeDay][5];
    tiDetailVC.bankString = _bankString;
    tiDetailVC.bankNumString = _bankNumString;
    tiDetailVC.moneyString = _moneyString;
    
    [tiDetailVC navBarTitle:@"提现详情"];
    [self presentViewController:tiDetailVC animated:YES completion:nil];
//    [self.navigationController pushViewController:tiDetailVC animated:YES];
}

- (void)creatPayView{
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.backgroundColor = kBlackColor;
    backButton.alpha = 0.8;
    backButton.frame = CGRectMake(0, 0, kScreenSize.width, kScreenSize.height);
    [backButton addTarget:self action:@selector(hiddenVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    _payView = [[UIView alloc] initWithFrame:CGRectMake(48, 130, kScreenSize.width - 100 + 4, 220)];
    _payView.backgroundColor = [kWhiteColor colorWithAlphaComponent:0.93];
    _payView.layer.masksToBounds = YES;
    _payView.layer.cornerRadius = kButtonCornerRadius *2;
    //关闭按钮
    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 19, 12, 12)];
//    [closeButton setBackgroundColor:kBlackColor];
    [closeButton setImage:[UIImage imageNamed:@"X.png"] forState:UIControlStateNormal];
    [closeButton setTitle:@"" forState:UIControlStateNormal];
    
    [closeButton addTarget:self action:@selector(hiddenVC) forControlEvents:UIControlEventTouchUpInside];
    
    [_payView addSubview:closeButton];
    
    //title
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _payView.sizeWidth, 50)];
    titleLabel.text = @"请输入支付密码";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [_payView addSubview:titleLabel];
    
    //greenLine
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, titleLabel.allHeight, _payView.sizeWidth, 0.5)];
    lineImageView.backgroundColor = kColorFrom0x(0x1AAD19);
    [_payView addSubview:lineImageView];
    
    //content
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, lineImageView.orginY + lineImageView.sizeHeight + 15, _payView.sizeWidth, 20)];
    contentLabel.text = @"提现";
    contentLabel.textAlignment = NSTextAlignmentCenter;
    contentLabel.font = [UIFont systemFontOfSize:16];
    [_payView addSubview:contentLabel];
    
    //moneyLable;
    UILabel * moneyLable = [[UILabel alloc] initWithFrame:CGRectMake(0, contentLabel.allHeight , _payView.sizeWidth, 50)];
    moneyLable.text = [NSString stringWithFormat:@"¥%.2lf",_moneyString.doubleValue];
    moneyLable.textAlignment = NSTextAlignmentCenter;
    moneyLable.font = [UIFont fontWithName:@"HelveticaNeue" size:36];
//    moneyLable.font = [UIFont systemFontOfSize:40];
    [_payView addSubview:moneyLable];
    
    //手续费
    UILabel *rateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, moneyLable.allHeight, _payView.sizeWidth, 20)];
    rateLabel.textColor = kColorFrom0x(0x666666);
    CGFloat rate = _moneyString.doubleValue *0.001;
    rateLabel.text = [NSString stringWithFormat:@"额外扣除¥%.2lf手续费",rate >0.1 ? rate : 0.1];
    rateLabel.textAlignment = NSTextAlignmentCenter;
    rateLabel.font = [UIFont systemFontOfSize:16];
    [_payView addSubview:rateLabel];
    
    //passwordTextField
    _pzxView = [[PZXVerificationCodeView alloc]initWithFrame:CGRectMake(15, rateLabel.allHeight + 20, _payView.sizeWidth - 30, (_payView.sizeWidth - 30)/6)];
    _pzxView.selectedColor = kd2d2d2;
    _pzxView.center = self.view.center;
    _pzxView.deselectColor = kd2d2d2;
    _pzxView.VerificationCodeNum = 6;
    _pzxView.isSecure = YES;
    _pzxView.Spacing = -0.5f;//每个格子间距属性
    
    _pzxView.layer.masksToBounds = YES;
    _pzxView.layer.borderWidth = 0.5f;
    _pzxView.layer.borderColor = [kColorFrom0x(0x7b7b7b) CGColor];
    [_payView addSubview:_pzxView];
    
    _pzxView.frame = CGRectMake(15, rateLabel.allHeight + 20, _payView.sizeWidth - 30, (_payView.sizeWidth - 30)/6);
    _payView.frame = CGRectMake(_payView.orginX, _payView.orginY, _payView.sizeWidth, _pzxView.allHeight + 20);
    [self.view addSubview:_payView];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    
    for (UITextField *tf in _pzxView.textFieldArray) {
        
        [tf resignFirstResponder];
    }
    //    [self.view endEditing:YES];
    
}

- (void)hiddenVC{
    [self dismissViewControllerAnimated:YES completion:nil];
//    [self.navigationController popViewControllerAnimated:ye]
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
