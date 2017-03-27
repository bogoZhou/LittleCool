//
//  IBeaconModel.h
//  noteMan
//
//  Created by 周博 on 16/12/15.
//  Copyright © 2016年 BogoZhou. All rights reserved.
//

/*
 "ibeacon": {    //盒子数据  ，如果未绑定盒子 是null
 "id": "1220",            //修改 盒子数据 需要传此 id
 "user_id": "1574",
 "marjor_id": "10083",
 "minor_id": "24370",     // 盒子编号
 "organization_id": "6",
 "status": "1",
 "dist_organization_id": "-1",
 "dist_status": "0",
 "rand_string": null,
 "ibeacon_alias": null      // 盒子设备名字
 }

 */

#import "BaseModel.h"

@interface IBeaconModel : BaseModel

@property (nonatomic,strong) NSString *id;
@property (nonatomic,strong) NSString *user_id;
@property (nonatomic,strong) NSString *marjor_id;
@property (nonatomic,strong) NSString *minor_id;
@property (nonatomic,strong) NSString *organization_id;
@property (nonatomic,strong) NSString *status;
@property (nonatomic,strong) NSString *dist_organization_id;
@property (nonatomic,strong) NSString *dist_status;
@property (nonatomic,strong) NSString *rand_string;
@property (nonatomic,strong) NSString *ibeacon_alias;

@end
