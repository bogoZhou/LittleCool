//
//  PosterJumpViewController.m
//  LittleCool
//
//  Created by 周博 on 2017/5/16.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "PosterJumpViewController.h"

@interface PosterJumpViewController ()

@end

@implementation PosterJumpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self UISetting];
}

- (void)UISetting{
    _buttonBack.backgroundColor = [kPosterBlack colorWithAlphaComponent:0.8];
    
    _ButtonUse.layer.masksToBounds = YES;
    _ButtonUse.layer.cornerRadius = 5;
    
    
    [_imageViewInScroll sd_setImageWithURL:[NSURL URLWithString:_mubanModel.preview] placeholderImage:kDefaultHeadImage];
}


#pragma mark- 点击事件

//点击背景返回
- (IBAction)backButtonClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)userNow:(UIButton *)sender {
    
//    kAlert(@"点击立即使用");
    
    [[AFClient shareInstance] getPosterDetailByUserId:kUserId udid:UDID material_id:_mubanModel.material_id progressBlock:nil success:^(id responseBody) {
        if ([responseBody[@"code"] integerValue] == 200) {
            NSLog(@"%@",responseBody[@"data"]);
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
