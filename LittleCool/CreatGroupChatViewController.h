//
//  CreatGroupChatViewController.h
//  Qian
//
//  Created by 周博 on 17/3/2.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "BaseViewController.h"

@interface CreatGroupChatViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UIScrollView *backScroll;
@property (weak, nonatomic) IBOutlet UIView *viewScroll;

//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutHeight;
//
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutWidth;

@property (weak, nonatomic) IBOutlet UITextField *textFieldGroupName;

@property (weak, nonatomic) IBOutlet UITextField *textFieldGroupNum;

@property (weak, nonatomic) IBOutlet UILabel *labelTrueNum;

@property (weak, nonatomic) IBOutlet UITextField *textFieldAutoAdd;

@property (weak, nonatomic) IBOutlet UIView *viewAutoAdd;

@property (weak, nonatomic) IBOutlet UIView *viewAddressBook;

//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutAutoAdd;

@end
