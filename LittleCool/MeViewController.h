//
//  MeViewController.h
//  Qian
//
//  Created by 周博 on 17/2/6.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "BaseViewController.h"

@interface MeViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewHeader;
@property (weak, nonatomic) IBOutlet UILabel *labelName;

@property (weak, nonatomic) IBOutlet UILabel *labelWechatNum;

@property (weak, nonatomic) IBOutlet UIView *myheadView;


@end
