//
//  MyPartViewController.m
//  noteMan
//
//  Created by 周博 on 16/12/9.
//  Copyright © 2016年 BogoZhou. All rights reserved.
//

#import "MyPartViewController.h"

@interface MyPartViewController ()
{
    BOOL _isOK;
}
@end

@implementation MyPartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self navBarTitle:@"我的设备"];
    [self navBarbackButton:@"        "];
        
    _viewName.hidden = [BGFunctionHelper isNULLOfString:_message] ? NO : YES;
//    _buttonOK.hidden = [BGFunctionHelper isNULLOfString:_message] ? YES : NO;
    
    if (![BGFunctionHelper isNULLOfString:_message]) {
        [self rightButtonClick:@"确认绑定"];
    }
    
//    _isOK = [BGFunctionHelper isNULLOfString:_message] ? YES : NO;
    
    _textFieldCode.text = _message ? _message : _ibeaconModel.minor_id;
    _textFieldName.text = [BGFunctionHelper isNULLOfString:_ibeaconModel.ibeacon_alias] ? @"" : _ibeaconModel.ibeacon_alias;
//    _textFieldName.placeholder = [BGFunctionHelper isNULLOfString:_ibeaconModel.ibeacon_alias] ? @"" :_ibeaconModel.ibeacon_alias;
    
}

#pragma mark - 点击事件

- (IBAction)backButtonClick:(UIButton *)sender {
    NSArray *array = self.navigationController.viewControllers;
    [self.navigationController popToViewController:array[0] animated:YES];
}

-(void)rightNavButtonClick{
//    kAlert(@"点击确认绑定");
    UIAlertController *alert= [UIAlertController alertControllerWithTitle:@"提示" message:@"您只能绑定一个设备，是否确认绑定" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"考虑一下" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"马上绑定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self bindBoxFun];
    }];
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)bindBoxFun{
    [[AFClient shareInstance] bindBoxByUserId:kUserId boxId:_beaconId progressBlock:^(NSProgress *progress) {
        
    } success:^(id responseBody) {
        if ([responseBody[@"code"] integerValue] ==200) {
            kAlert(@"绑定成功");
            _viewName.hidden = NO;
            [self rightButtonClick:@""];
        }else{
            kAlert(responseBody[@"message"]);
        }
    } failure:^(NSError *error) {
        
    }];
}

- (IBAction)changeNameButtonClick:(UIButton *)sender {
//    kAlert(@"点击修改");
    if ([BGFunctionHelper isNULLOfString:_textFieldName.text]) {
        kAlert(@"请输入设备名");
        return;
    }
    if ([_textFieldName.text length] > 10) {
        kAlert(@"设备名应在10个字以内");
        return;
    }
    [self changeIbeaconName];
}


//修改设备名字
- (void)changeIbeaconName{
    [[AFClient shareInstance] updateBoxNameByUserId:kUserId boxId:_beaconId name:_textFieldName.text progressBlock:^(NSProgress *progress) {
        
    } success:^(id responseBody) {
        if ([responseBody[@"code"] integerValue] == 200) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"修改成功" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                NSArray *array = self.navigationController.viewControllers;
                [self.navigationController popToViewController:array[0] animated:YES];
            }];
            
            [alert addAction:OKAction];
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
