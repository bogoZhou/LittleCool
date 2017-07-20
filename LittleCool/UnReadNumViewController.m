//
//  UnReadNumViewController.m
//  Qian
//
//  Created by 周博 on 17/2/24.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "UnReadNumViewController.h"

@interface UnReadNumViewController ()

@end

@implementation UnReadNumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navBarTitle:@"设置未读消息"];
    [self navBarbackButton:@"返回"];
    [self wechatRightButtonClick:@"完成" ];
}


//清空未读消息
- (IBAction)unReadButtonClick:(UIButton *)sender {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确认要删除吗？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

    }];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[[self.tabBarController tabBar] items] objectAtIndex:1].badgeValue = nil;
        
        [[[self.tabBarController tabBar] items] objectAtIndex:2].badgeValue = nil;
    }];

    [alert addAction:cancelAction];
    [alert addAction:sureAction];

    [self presentViewController:alert animated:YES completion:nil];
}

- (void)rightNavButtonClick{
    
    if (![BGFunctionHelper isNULLOfString:_textField0.text]) {
        [[[self.tabBarController tabBar] items] objectAtIndex:1].badgeValue = _textField0.text;
    }
    if (![BGFunctionHelper isNULLOfString:_textField1.text]) {
        [[[self.tabBarController tabBar] items] objectAtIndex:2].badgeValue = _textField1.text;
    }
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
