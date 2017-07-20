//
//  UserInfoViewController.h
//  Qian
//
//  Created by 周博 on 17/2/7.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "BaseViewController.h"

@interface UserInfoViewController : BaseViewController

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutWidth;


@property (weak, nonatomic) IBOutlet UIImageView *imageViewHeader;

@property (weak, nonatomic) IBOutlet UILabel *labelNickName;

@property (weak, nonatomic) IBOutlet UILabel *labelWechatNum;

@end
