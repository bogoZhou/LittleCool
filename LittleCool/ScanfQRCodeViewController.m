//
//  ScanfQRCodeViewController.m
//  noteMan
//
//  Created by 周博 on 16/12/12.
//  Copyright © 2016年 BogoZhou. All rights reserved.
//

#import "ScanfQRCodeViewController.h"
#import "BGScanQRCodeHelper.h"
#import "MyPartViewController.h"
#import "AFClient.h"
#import "IBeaconModel.h"

@interface ScanfQRCodeViewController ()<BGScanQRCodeHelperDelegate>

@end

@implementation ScanfQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self BGScan];
    
    [self navBarTitle:@"扫描设备"];
    [self navBarbackButton:@"        "];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (![[BGScanQRCodeHelper manager] isRunning]) {
        [[BGScanQRCodeHelper manager] startRunning];
    }
}

- (void)BGScan{
    [[BGScanQRCodeHelper manager] setSupperView:self.view];
    [[BGScanQRCodeHelper manager] setScanningRect:_viewScanf.frame scanView:_viewScanf];
    [BGScanQRCodeHelper manager].delegate = self;
    [[BGScanQRCodeHelper manager] startRunning];
}

- (void)resaultString:(NSString *)resault{
    [[BGScanQRCodeHelper manager] stopRunning];
    [self findResault:resault];
}

- (void)findResault:(NSString *)resault{
    [[AFClient shareInstance] readQRCodeToFindBoxByUserId:kUserId rand_string:resault progressBlock:^(NSProgress *progress) {
        
    } success:^(id responseBody) {
        if ([responseBody[@"code"] integerValue] == 200) {
            IBeaconModel *ibeaconModel = [[IBeaconModel alloc] init];
            [ibeaconModel setValuesForKeysWithDictionary:responseBody[@"data"]];
            
            UIStoryboard *storyboard = kMainStroyboard;
            MyPartViewController *myPartVC = [storyboard instantiateViewControllerWithIdentifier:@"MyPartViewController"];
            myPartVC.message = ibeaconModel.minor_id;
            myPartVC.beaconId = ibeaconModel.id;
            [self.navigationController pushViewController:myPartVC animated:YES];
        }else{
            kAlert(responseBody[@"message"]);
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - 点击事件
- (IBAction)backButtonClick:(UIButton *)sender {
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
