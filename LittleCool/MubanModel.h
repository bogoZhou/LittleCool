//
//  MubanModel.h
//  LittleCool
//
//  Created by 周博 on 2017/5/16.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

/*
 "id": "2",
 "label_id": "8",
 "material_id": "1414",
 "template_type": "1",
 "scale": "37",
 "credit": "0",
 "grade": "0",
 "pic_num_max": "3",
 "is_exchange": "0",
 "is_favorite": "0",
 "preview_click": "https://st0.dancf.com/www/15018/design/20161123-211807-77.jpg?imageView2/2/w/600",
 "preview": "https://st0.dancf.com/www/15018/design/20161123-211807-77.jpg",
 "template_modified": "1493344125",
 "promo_icon_url": "",
 "has_buy": "0",
 "created": "2017-05-08 11:55:49",
 "status": "1",
 "font_url": null
 */

#import "BaseModel.h"

@interface MubanModel : BaseModel
@property (nonatomic,strong) NSString *id;
@property (nonatomic,strong) NSString *label_id;
@property (nonatomic,strong) NSString *material_id;
@property (nonatomic,strong) NSString *template_type;
@property (nonatomic,strong) NSString *scale;
@property (nonatomic,strong) NSString *credit;
@property (nonatomic,strong) NSString *grade;
@property (nonatomic,strong) NSString *pic_num_max;
@property (nonatomic,strong) NSString *is_exchange;
@property (nonatomic,strong) NSString *is_favorite;
@property (nonatomic,strong) NSString *preview_click;
@property (nonatomic,strong) NSString *preview;
@property (nonatomic,strong) NSString *template_modified;
@property (nonatomic,strong) NSString *promo_icon_url;
@property (nonatomic,strong) NSString *has_buy;
@property (nonatomic,strong) NSString *created;
@property (nonatomic,strong) NSString *status;
@property (nonatomic,strong) NSString *font_url;

@end
