//
//  ChatRedPacketModel.h
//  Qian
//
//  Created by 周博 on 17/3/8.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "BaseModel.h"

@interface ChatRedPacketModel : BaseModel
@property (nonatomic,strong) NSString *Id;
@property (nonatomic,strong) NSString *redMoney;
@property (nonatomic,strong) NSString *redSurplusMoney;
@property (nonatomic,strong) NSString *redNum;
@property (nonatomic,strong) NSString *redSurplusNum;
@property (nonatomic,strong) NSString *creatDate;
@property (nonatomic,strong) NSString *endDate;
@property (nonatomic,strong) NSString *redContent;
@end
