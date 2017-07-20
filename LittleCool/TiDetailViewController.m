//
//  TiDetailViewController.m
//  Qian
//
//  Created by 周博 on 17/3/6.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "TiDetailViewController.h"
#import "TiViewController.h"
#import "BorderHelper.h"

@interface TiDetailViewController ()

@end

@implementation TiDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self UISetting];
}

- (void)UISetting{
    _labelDate.text = _dateString;
    
    _labelBankNum.text = [NSString stringWithFormat:@"%@ 尾号%@",_bankString,_bankNumString];
    
    _labelMoney.text = [NSString stringWithFormat:@"¥%.2lf",_moneyString.doubleValue];

    CGFloat rate = _moneyString.doubleValue *0.001;
    
    _labelRate.text = [NSString stringWithFormat:@"¥%.2lf",rate > 0.1 ? rate : 0.1];
    
    [BorderHelper setBorderWithColor:kChatGreenBorder button:_buttonSuccess];
}



//点击完成按钮
- (IBAction)successButtonClick:(UIButton *)sender {

    UIViewController *vc = self.presentingViewController;
//    vc = vc.presentingViewController;
    vc = vc.presentingViewController;
    [vc dismissViewControllerAnimated:YES completion:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"backback" object:nil];
//    [self.navigationController popToViewController:self.navigationController.viewControllers[2] animated:YES];
}

/**
 设置状态栏颜色
 
 @return <#return value description#>
 */
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
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
