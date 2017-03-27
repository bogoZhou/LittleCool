//
//  InviteCodeViewController.m
//  LittleCool
//
//  Created by 周博 on 17/3/13.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "InviteCodeViewController.h"

@interface InviteCodeViewController ()
{
    
}
@end

@implementation InviteCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navBarTitle:@"我的邀请码"];
    [self navBarbackButton:@"       "];
    [self rightButtonClick:@"使用邀请码"];
    
    if ([kIsVip integerValue] == 200) {
        [self checkIsBind];
        [self rightButtonClick:@""];
    }
    [self ishiddenView];
}

- (void)checkIsBind{
    [[AFClient shareInstance] empowerByUserId:kUserId udid:UDID progressBlock:^(NSProgress *progress) {
        
    } success:^(id responseBody) {
        if ([responseBody[@"code"] integerValue] == 200) {
            _labelCode.text = responseBody[@"data"];
            _labelDate.text = @"永久";
            [[NSUserDefaults standardUserDefaults] setValue:@"200" forKey:@"isVip"];
        }else{
//            kAlert(responseBody[@"message"]);
            [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"isVip"];
        }
    } failure:^(NSError *error) {
        
    }];
}


- (void)ishiddenView{
    [[AFClient shareInstance] hiddenViewProgressBlock:^(NSProgress *progress) {
        
    } success:^(id responseBody) {
        if ([responseBody[@"code"] integerValue] == 200) {
            if ([responseBody[@"data"] integerValue] < 0) {
                _labelCode.text = @"jdu347fhjj";
                _labelDate.text = @"永久";
                [[NSUserDefaults standardUserDefaults] setValue:@"200" forKey:@"isVip"];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)rightNavButtonClick{
//    kAlert(@"使用邀请码");
    [self jumpAlertViewToGetCode];
}

- (void)jumpAlertViewToGetCode{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"邀请码" message:@"输入并绑定邀请码" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *newZanList = [UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UITextField *textField = alert.textFields.lastObject;
        
        [self bindEquementCode:textField.text];

    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"请输入邀请码";
    }];
    
    [alert addAction:newZanList];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)bindEquementCode:(NSString *)code{
    [[AFClient shareInstance] empowerAuthCodeByUserId:kUserId auth_code:code udid:UDID equipment_type:@"1" progressBlock:^(NSProgress *progress) {
        
    } success:^(id responseBody) {
        if ([responseBody[@"code"] integerValue] == 200) {
            kAlert(@"绑定成功");
            [self checkIsBind];
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"绑定成功" message:@"请重新打开App以获得VIP功能" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *newZanList = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

            }];
            [alert addAction:newZanList];
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
