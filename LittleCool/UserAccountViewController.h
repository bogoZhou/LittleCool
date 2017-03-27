//
//  UserAccountViewController.h
//  noteMan
//
//  Created by 周博 on 16/12/15.
//  Copyright © 2016年 BogoZhou. All rights reserved.
//

#import "BaseViewController.h"

@interface UserAccountViewController : BaseViewController

@property (nonatomic,strong) NSString *moneyStr;

@property (nonatomic,strong) NSString *withDrowMoneyStr;

@property (weak, nonatomic) IBOutlet UILabel *labelMoney;

@end
