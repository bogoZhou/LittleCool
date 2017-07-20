//
//  FriendsModel.h
//  Qian
//
//  Created by 周博 on 17/2/19.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "BaseModel.h"

@interface FriendsModel : BaseModel

@property (nonatomic,strong) NSString *Id;
@property (nonatomic,strong) NSString *userId;
@property (nonatomic,strong) NSString *textContent;
@property (nonatomic,strong) NSString *date;

@end
