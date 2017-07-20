//
//  BankCardModel.h
//  Qian
//
//  Created by 周博 on 17/3/6.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "BaseModel.h"

@interface BankCardModel : BaseModel
@property (nonatomic,strong) NSString *Id;
@property (nonatomic,strong) NSString *bankName;
@property (nonatomic,strong) NSString *bankNum;
@end
