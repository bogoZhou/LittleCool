//
//  WechatTabBarViewController.m
//  Qian
//
//  Created by 周博 on 17/2/6.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "WechatTabBarViewController.h"

@interface WechatTabBarViewController ()

@end

@implementation WechatTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tabBar.tintColor = kWechatTabBarColor;
    self.tabBar.barTintColor = [UIColor whiteColor];
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
