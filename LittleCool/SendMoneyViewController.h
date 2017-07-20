//
//  SendMoneyViewController.h
//  Qian
//
//  Created by 周博 on 17/2/22.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "BaseViewController.h"

@interface SendMoneyViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UITextField *textFieldMoney;

@property (weak, nonatomic) IBOutlet UITextField *textFieldSendTime;
@property (weak, nonatomic) IBOutlet UITextField *textFieldGetTime;

@property (weak, nonatomic) IBOutlet UITextField *textFieldContent;

@end
