//
//  WechatPayModel.h
//  Qian
//
//  Created by 周博 on 17/3/11.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "BaseModel.h"

@interface WechatPayModel : BaseModel
//@"Id",@"type",@"money",@"startDate",@"endDate",@"remark",@"reason",@"userName"
@property (nonatomic,strong) NSString *Id;
@property (nonatomic,strong) NSString *type;
@property (nonatomic,strong) NSString *money;
@property (nonatomic,strong) NSString *startDate;
@property (nonatomic,strong) NSString *endDate;
@property (nonatomic,strong) NSString *remark;
@property (nonatomic,strong) NSString *reason;
@property (nonatomic,strong) NSString *userName;
@end
