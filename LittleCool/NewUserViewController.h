//
//  NewUserViewController.h
//  Qian
//
//  Created by 周博 on 17/2/8.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "BaseViewController.h"

@interface NewUserViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UIImageView *imageViewHeader;

@property (weak, nonatomic) IBOutlet UITextField *textFieldNickName;

@property (weak, nonatomic) IBOutlet UITextField *textFieldWechatNum;

@property (nonatomic,strong) NSString *willChange;

@end
