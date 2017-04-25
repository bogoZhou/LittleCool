//
//  SignViewController.h
//  LittleCool
//
//  Created by 周博 on 17/3/13.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *imageViewHeader;

@property (weak, nonatomic) IBOutlet UITextField *textFieldMobile;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewCenterLine;

@property (weak, nonatomic) IBOutlet UITextField *textFieldCode;

@property (weak, nonatomic) IBOutlet UIButton *getCodeButton;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;


@end
