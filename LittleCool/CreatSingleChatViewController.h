//
//  CreatSingleChatViewController.h
//  Qian
//
//  Created by 周博 on 17/3/2.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "BaseViewController.h"

@interface CreatSingleChatViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIScrollView *backScroll;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutWidth;

@property (weak, nonatomic) IBOutlet UIView *viewDeep;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewHeader;

@property (weak, nonatomic) IBOutlet UITextField *textFieldNickName;

@property (weak, nonatomic) IBOutlet UITextField *textFieldDate;

@property (weak, nonatomic) IBOutlet UITextField *textFieldContent1;
@property (weak, nonatomic) IBOutlet UITextField *textFieldContent2;
@property (weak, nonatomic) IBOutlet UITextField *textFieldContent3;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewHalf;
@property (weak, nonatomic) IBOutlet UIImageView *imageviewAll;

@property (weak, nonatomic) IBOutlet UISwitch *switchButton;


@end
