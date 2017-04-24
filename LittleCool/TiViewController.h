//
//  TiViewController.h
//  Qian
//
//  Created by 周博 on 17/2/9.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "BaseViewController.h"

@interface TiViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UITextView *textViewMoney;

@property (weak, nonatomic) IBOutlet UILabel *labelAllMoney;

@property (weak, nonatomic) IBOutlet UIButton *buttonTixian;

@property (weak, nonatomic) IBOutlet UILabel *labelTime;

@property (weak, nonatomic) IBOutlet UIView *viewBankCard;

@property (weak, nonatomic) IBOutlet UIView *viewTextView;

@property (weak, nonatomic) IBOutlet UILabel *labelBank;

@property (weak, nonatomic) IBOutlet UILabel *labelBankRate;

@property (weak, nonatomic) IBOutlet UILabel *labelAllCash;

@end
