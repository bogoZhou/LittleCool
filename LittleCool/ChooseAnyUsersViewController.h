//
//  ChooseAnyUsersViewController.h
//  Qian
//
//  Created by 周博 on 17/2/25.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "BaseViewController.h"

@interface ChooseAnyUsersViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSString *chooseNum;

@property (nonatomic,strong) NSString *userIds;

@property (nonatomic,strong) NSString *notiName;

@property (nonatomic,strong) NSString *redPacketId;

@end

