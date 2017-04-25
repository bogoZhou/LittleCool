//
//  WithDrawViewController.m
//  noteMan
//
//  Created by 周博 on 16/12/15.
//  Copyright © 2016年 BogoZhou. All rights reserved.
//

#import "WithDrawViewController.h"

@interface WithDrawViewController ()<UITextFieldDelegate>
{
    NSString * _alipay_account;
    NSString * _alipay_name;
    NSInteger _choosePayWay;//1,支付宝；2，微信
}
@end

@implementation WithDrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navBarTitle:@"提现转出"];
    [self navBarbackButton:@"        "];
    [self firstStept];
    [self bournButtonClick:_buttonWechat];
}

- (void)firstStept{
    _textFieldMoney.placeholder = [NSString stringWithFormat:@"一共可提现%@元",_withDrawMoney];
}

#pragma mark - 点击事件

- (IBAction)backButtonClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//101 -> 支付宝(大额提现) ;102 -> 微信
- (IBAction)bournButtonClick:(UIButton *)sender {
    if (sender.tag == 101) {
        _imageViewChoose.image = kSelect;
        _imageViewWechatChoose.image = kUnselect;
        _choosePayWay = 1;
    }else{
        _imageViewWechatChoose.image = kSelect;
        _imageViewChoose.image = kUnselect;
        _choosePayWay = 2;
    }
}

//马上体现
- (IBAction)withDrawNowButtonClick:(UIButton *)sender {
    BOOL money1 = [BGFunctionHelper isNULLOfString:_textFieldMoney.text];
    BOOL money2 = _textFieldMoney.text.floatValue <= 0;
    BOOL money3 = _textFieldMoney.text.floatValue > _withDrawMoney.floatValue;
    if (money1) {
        kAlert(@"请输入提现金额");
        return;
    }
    if (money2) {
        kAlert(@"请输入正确提现金额");
        return;
    }
    if (money3) {
        kAlert(@"提现金额不足");
        return;
    }
    if (_choosePayWay == 2) {
        //提现到微信
        
        if (_textFieldMoney.text.doubleValue >= 200) {
            kAlert(@"提现金额大于200，请选择大额提现");
            return;
        }
        
        [self weChatFun];
    }else{
        if (_textFieldMoney.text.doubleValue < 200 || _textFieldMoney.text.doubleValue > 2000) {
            kAlert(@"提现金额应在200 - 2000 元范围内");
            return;
        }
        [self wechatBigWithDrawFun];
    }
}

//微信小额提现
- (void)weChatFun{
    [[AFClient shareInstance] getMyMoneyByUserId:kUserId progressBlock:^(NSProgress *progress) {
        
    } success:^(id responseBody) {
        if ([responseBody[@"code"] integerValue] == 200) {
            NSDictionary * dic = responseBody[@"data"];
            if ([dic[@"status"] integerValue] == 1) {
                [[AFClient shareInstance] getWIthDrawalsByWeChatByUserid:kUserId money:_textFieldMoney.text progressBlock:^(NSProgress *progress) {
                    
                } success:^(id responseBody) {
                    if ([responseBody[@"code"] integerValue] == 200) {
                        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提现成功" message:@"提现金额将在24小时内到账" preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            NSArray * ctrlArray = self.navigationController.viewControllers;
                            [self.navigationController popToViewController:[ctrlArray objectAtIndex:0] animated:YES];
                        }];
                        [alert addAction:sure];
                        [self presentViewController:alert animated:YES completion:nil];
                        
                    }else{
                        kAlert(responseBody[@"message"]);
                    }
                } failure:^(NSError *error) {
                    
                }];
            }else{
                //                    kAlert(@"请先在微信中关注公众号--”全民纸条客“");
                UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请先在微信中关注公众号--“全民纸条客”" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *sure = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [alert addAction:sure];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }else{
            kAlert(responseBody[@"message"]);
        }
    } failure:^(NSError *error) {
        if (error) {
            kAlert(@"与服务器链接异常，请重试")
        }
    }];
}

//wechat大额提现
- (void)wechatBigWithDrawFun{
    [[AFClient shareInstance] getBigWithDrawalsByWeChatByUserid:kUserId money:_textFieldMoney.text progressBlock:^(NSProgress *progress) {
        
    } success:^(id responseBody) {
        if ([responseBody[@"code"] integerValue] == 200) {
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提现成功" message:@"提现金额将在72小时内到账" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *sure = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSArray * ctrlArray = self.navigationController.viewControllers;
                [self.navigationController popToViewController:[ctrlArray objectAtIndex:0] animated:YES];
            }];
            [alert addAction:sure];
            [self presentViewController:alert animated:YES completion:nil];
        }else{
            kAlert(responseBody[@"message"]);
        }
    } failure:^(NSError *error) {
        
    }];
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
