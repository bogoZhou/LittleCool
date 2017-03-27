//
//  BaseViewController.m
//  LittleCool
//
//  Created by 周博 on 17/3/12.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tabBarController.tabBar.hidden = YES;
}

- (void)navBarTitle:(NSString *)title{
    UILabel *titleLabel = [[UILabel
                            alloc] initWithFrame:CGRectMake(0,0, 200, 44)];
    titleLabel.backgroundColor = kClearColor;
    
    titleLabel.font = [UIFont boldSystemFontOfSize:19];
    
    
    titleLabel.textColor = kWhiteColor;
    
    titleLabel.textAlignment =  NSTextAlignmentCenter;
    
    titleLabel.text = title;
    
    self.navigationItem.titleView = titleLabel;
}

/**
 设置左边返回按钮
 
 @param title 返回名称
 @param tFloat 返回文字左边间隔
 */
- (void)navBarbackButton:(NSString *)title{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 6, 11, 18)];
    [button setImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backLastPage) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    
    CGSize titleSize = [title boundingRectWithSize:CGSizeMake(kScreenSize.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size;
    
    [button1 setFrame:CGRectMake(15, 0, titleSize.width, 30)];
    [button1 setTitle:title forState:UIControlStateNormal];
    button1.titleLabel.font = [UIFont systemFontOfSize:16];
    [button1 addTarget:self action:@selector(backLastPage) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -10;
    
    UIView * leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    
    [leftView addSubview:button];
    [leftView addSubview:button1];
    
    UIBarButtonItem*leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftView];
    
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer,leftItem, nil];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
}


/**
 返回键点击事件
 */
- (void)backLastPage{
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 nav右边按钮
 
 @param string 右边按钮文字
 */
- (void)rightButtonClick:(NSString *)string{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:string forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    CGSize titleSize = [string boundingRectWithSize:CGSizeMake(kScreenSize.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
    [button setFrame:CGRectMake(0, 0, titleSize.width, 30)];
    
    button.titleLabel.textAlignment = NSTextAlignmentRight;
    [button addTarget:self action:@selector(rightNavButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*leftItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = 0;
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer,leftItem, nil];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
}

- (void)rightNavButtonClick{
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
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
