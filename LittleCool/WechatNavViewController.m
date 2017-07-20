//
//  WechatNavViewController.m
//  Qian
//
//  Created by 周博 on 17/2/6.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "WechatNavViewController.h"

@interface WechatNavViewController ()

@end

@implementation WechatNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBar.translucent = NO;
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"WechatNavBar.jpg"] forBarMetrics:UIBarMetricsDefault];
//    self.navigationBar.backgroundColor = kColorFrom0x(0x2d2c33);
//    self.navigationBar.alpha = 0.8;
    self.navigationBar.barStyle = UIBarStyleBlackOpaque;

}

- (void)setNavBar{
    UIView *titleV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, 64)];
    self.navigationController.navigationItem.titleView  = titleV;
    
    self.navigationController.navigationItem.title = @"微信";
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
