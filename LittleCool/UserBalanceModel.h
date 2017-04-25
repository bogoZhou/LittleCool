//
//  UserBalanceModel.h
//  FastHelp
//
//  Created by 周博 on 16/6/29.
//  Copyright © 2016年 BogoZhou. All rights reserved.
//
/**
 balance = "0.00";
 id = 3;
 status = 1;
 "user_id" = 83;
 
 "id": "190",
 "user_id": "1",
 "balance": "150.00",
 "withdrawals_balance": "50.00",
 "cold_balance": "100.00",
 "status": "1"
 */

#import "BaseModel.h"

@interface UserBalanceModel : BaseModel
@property (nonatomic,strong) NSString *balance;
@property (nonatomic,strong) NSString *id;
@property (nonatomic,strong) NSString *status;
@property (nonatomic,strong) NSString *user_id;
@property (nonatomic,strong) NSString *withdrawals_balance;
@property (nonatomic,strong) NSString *cold_balance;
@end
