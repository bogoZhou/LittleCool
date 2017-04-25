//
//  BaseViewController.h
//  LittleCool
//
//  Created by 周博 on 17/3/12.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController
{
    
}

- (void)navBarTitle:(NSString *)title;

- (void)clickNavTitle:(UIButton *)button;

- (void)navBarbackButton:(NSString *)title;

- (void)creatTabBar;

- (void)rightButtonClick:(NSString *)string;

- (void)rightNavButtonClick;

- (void)wechatRightButtonClick:(NSString *)string;

- (void)backLastPage;

- (void)navBarbackButtonNoLeft:(NSString *)title textFloat:(CGFloat)tFloat;

- (NSString *)countDate:(NSString *)dateString;

- (void)creatGestureOnScrollView:(UIScrollView *)scrollView;
@end
