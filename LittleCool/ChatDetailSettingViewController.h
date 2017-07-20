//
//  ChatDetailSettingViewController.h
//  Qian
//
//  Created by 周博 on 17/2/24.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "BaseViewController.h"

@interface ChatDetailSettingViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UIImageView *imageViewHeader;

@property (weak, nonatomic) IBOutlet UITextField *textFieldUserName;

@property (weak, nonatomic) IBOutlet UISwitch *mySwitch;

@property (nonatomic,strong) NSString *userId;

@property (nonatomic,strong) NSString *chatRoomId;

@end
