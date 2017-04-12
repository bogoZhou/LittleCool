//
//  LabelsModel.h
//  LittleCool
//
//  Created by 周博 on 17/4/10.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

/*
 "id": "2",
 "name": "晚安",
 "created": "2017-04-10 16:09:01",
 "status": "1",
 "vip_grade": "1",
 "sort": "1"
*/

#import "BaseModel.h"

@interface LabelsModel : BaseModel

@property (nonatomic,strong) NSString *id;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *created;
@property (nonatomic,strong) NSString *status;
@property (nonatomic,strong) NSString *vip_grade;
@property (nonatomic,strong) NSString *sort;

@end
