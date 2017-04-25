//
//  WithDrawViewController.h
//  noteMan
//
//  Created by 周博 on 16/12/15.
//  Copyright © 2016年 BogoZhou. All rights reserved.
//

#import "BaseViewController.h"

@interface WithDrawViewController : BaseViewController

@property (nonatomic,strong) NSString *withDrawMoney;

@property (weak, nonatomic) IBOutlet UITextField *textFieldMoney;


@property (weak, nonatomic) IBOutlet UIImageView *imageViewChoose;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewWechatChoose;
@property (weak, nonatomic) IBOutlet UIButton *buttonWechat;
@property (weak, nonatomic) IBOutlet UIButton *buttonBigWechat;

@end
