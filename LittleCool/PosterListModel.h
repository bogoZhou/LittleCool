//
//  PosterListModel.h
//  LittleCool
//
//  Created by 周博 on 2017/5/16.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

/*
 "id": "1",
 "label_id": "8",
 "label": "最新上架 - 微商发圈天天有料",
 "img_url": null,
 "jump_url": null,
 "label_color": null,
 "label_len": null,
 "created": "2017-05-08 11:55:04",
 "style": "0",
 "status": "1",
 muban_data -> list
 */

#import "BaseModel.h"

@interface PosterListModel : BaseModel
@property (nonatomic,strong) NSString *id;
@property (nonatomic,strong) NSString *label_id;
@property (nonatomic,strong) NSString *label;
@property (nonatomic,strong) NSString *img_url;
@property (nonatomic,strong) NSString *jump_url;
@property (nonatomic,strong) NSString *label_color;
@property (nonatomic,strong) NSString *label_len;
@property (nonatomic,strong) NSString *created;
@property (nonatomic,strong) NSString *style;
@property (nonatomic,strong) NSString *status;
@property (nonatomic,strong) NSArray *muban_data;
@end
