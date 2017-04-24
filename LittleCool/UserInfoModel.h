//
//  UserInfoModel.h
//  Qian
//
//  Created by 周博 on 17/2/13.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "BaseModel.h"

@interface UserInfoModel : BaseModel

@property (nonatomic,strong) NSString *Id;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *wechatNum;
@property (nonatomic,strong) NSString *money;
@property (nonatomic,strong) NSString *headImage;

@end
