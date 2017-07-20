//
//  ChatDetailViewController.h
//  Qian
//
//  Created by 周博 on 17/2/10.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "BaseViewController.h"
#import "UserInfoModel.h"

@interface ChatDetailViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *viewTextPut;

@property (weak, nonatomic) IBOutlet UITextField *textFieldPut;

@property (weak, nonatomic) IBOutlet UIView *viewInput;

@property (weak, nonatomic) IBOutlet UIView *viewHandle;

@property (weak, nonatomic) IBOutlet UIButton *buttonSound;

@property (nonatomic,strong) NSString *roomId;

@property (nonatomic,strong) NSString *userId;

@property (nonatomic,strong) NSString *groupUsersId;

@end
