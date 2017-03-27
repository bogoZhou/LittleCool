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

- (void)navBarbackButton:(NSString *)title;

- (void)creatTabBar;

- (void)rightButtonClick:(NSString *)string;

- (void)rightNavButtonClick;
@end
