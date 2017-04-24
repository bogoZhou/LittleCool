//
//  MoneyListViewController.h
//  Qian
//
//  Created by 周博 on 17/2/16.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "BaseViewController.h"
#import "MoneyModel.h"

@interface MoneyListViewController : BaseViewController
{
    
}
@property (nonatomic,strong) MoneyModel *moneyModel;

@property (weak, nonatomic) IBOutlet UITextField *textFieldMoney;

@property (weak, nonatomic) IBOutlet UITextField *textFieldName;

@property (weak, nonatomic) IBOutlet UITextField *textFieldDate;


@end
