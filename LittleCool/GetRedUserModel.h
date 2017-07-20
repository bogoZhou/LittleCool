//
//  GetRedUserModel.h
//  Qian
//
//  Created by 周博 on 17/3/8.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "BaseModel.h"

@interface GetRedUserModel : BaseModel
@property (nonatomic,strong) NSString *Id;
@property (nonatomic,strong) NSString *userId;
@property (nonatomic,strong) NSString *redId;
@property (nonatomic,strong) NSString *getMoneyNum;
@property (nonatomic,strong) NSString *getMoneyDate;
@property (nonatomic,strong) NSString *isGreat;
@end
