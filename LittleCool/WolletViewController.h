//
//  WolletViewController.h
//  Qian
//
//  Created by 周博 on 17/2/8.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "BaseViewController.h"

@interface WolletViewController : BaseViewController

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutView0;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutView1;

@property (weak, nonatomic) IBOutlet UIView *view0;
@property (weak, nonatomic) IBOutlet UIView *view1;

@property (weak, nonatomic) IBOutlet UILabel *labelMoney;

@property (weak, nonatomic) IBOutlet UIView *viewTengxunfuwu;
@property (weak, nonatomic) IBOutlet UIView *viewDisanfang;

@property (weak, nonatomic) IBOutlet UIView *viewTop;


#pragma mark - 收付款,零钱,银行卡
@property (weak, nonatomic) IBOutlet UIView *viewShoufukuan;
@property (weak, nonatomic) IBOutlet UIView *viewLingqian;
@property (weak, nonatomic) IBOutlet UIView *viewYinhangka;


@end
