//
//  VerifyPartViewController.m
//  noteMan
//
//  Created by 周博 on 16/12/9.
//  Copyright © 2016年 BogoZhou. All rights reserved.
//

#import "VerifyPartViewController.h"
#import "MyPartViewController.h"

@interface VerifyPartViewController ()

@end

@implementation VerifyPartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navBarTitle:@"我的设备"];
    [self navBarbackButton:@"        "];
}



#pragma mark - 点击事件

- (IBAction)backButtonClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//扫描二维码
- (IBAction)scanf2DCodeButtonClick:(UIButton *)sender {
//    kAlert(@"点击扫面二维码");

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
