//
//  CitysModel.h
//  LittleCool
//
//  Created by 周博 on 17/3/14.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "BaseModel.h"

/**
 "id": "34",     //标签id  查看标签下的视频时会使用
 "name": "广州",   //标签名字
 "vip_grade": "0",
 "status": "1",
 "created": "2017-02-28 13:15:41"
 */
@interface CitysModel : BaseModel
@property (nonatomic,strong) NSString *id;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *vip_grade;
@property (nonatomic,strong) NSString *status;
@property (nonatomic,strong) NSString *created;
@property (nonatomic,strong) NSString *countNew;
@end
