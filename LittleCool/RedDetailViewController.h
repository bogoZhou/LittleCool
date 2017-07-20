//
//  RedDetailViewController.h
//  Qian
//
//  Created by 周博 on 17/3/9.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "BaseViewController.h"

@interface RedDetailViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewHeader;

@property (weak, nonatomic) IBOutlet UILabel *labelName;

@property (weak, nonatomic) IBOutlet UIView *viewPin;

@property (weak, nonatomic) IBOutlet UILabel *labelRedContent;

@property (weak, nonatomic) IBOutlet UILabel *labelMoney;

@property (weak, nonatomic) IBOutlet UILabel *labelUnit;

@property (weak, nonatomic) IBOutlet UILabel *labelContent;

@property (nonatomic,strong) NSString *redId;

@property (weak, nonatomic) IBOutlet UIView *viewMyGet;

@property (weak, nonatomic) IBOutlet UIView *headView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutHeadImageHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutContentHeight;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewBg;
@end
