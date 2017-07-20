//
//  PosterDetailViewController.m
//  LittleCool
//
//  Created by 周博 on 2017/5/18.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "PosterDetailViewController.h"

@interface PosterDetailViewController ()

@end

@implementation PosterDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self UISetting];
}

- (void)UISetting{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _scrollView.sizeWidth, _posterDetailModel.layout.height.doubleValue / (_posterDetailModel.layout.width.doubleValue/_scrollView.sizeWidth))];
    
    LayoutModel *layoutModel = [[LayoutModel alloc] init];
    layoutModel = [_posterDetailModel.layout.fixedelement firstObject];
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:layoutModel.backgroundImage] placeholderImage:kDefaultHeadImage];
    
    [_scrollView addSubview:imageView];
    _scrollView.contentSize = CGSizeMake(imageView.sizeWidth, imageView.sizeHeight);
}


#pragma mark - 点击事件
//返回
- (IBAction)backButtonClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//点击完成
- (IBAction)finishButtonClick:(UIButton *)sender {
    
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
