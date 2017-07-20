//
//  TiDetailViewController.h
//  Qian
//
//  Created by 周博 on 17/3/6.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "BaseViewController.h"

@interface TiDetailViewController : BaseViewController

@property (nonatomic,strong) NSString *dateString;

@property (nonatomic,strong) NSString *bankString;

@property (nonatomic,strong) NSString *bankNumString;

@property (nonatomic,strong) NSString *moneyString;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewHeader;

@property (weak, nonatomic) IBOutlet UILabel *labelDate;

@property (weak, nonatomic) IBOutlet UILabel *labelBankNum;

@property (weak, nonatomic) IBOutlet UILabel *labelMoney;

@property (weak, nonatomic) IBOutlet UIButton *buttonSuccess;

@property (weak, nonatomic) IBOutlet UILabel *labelRate;
@end
