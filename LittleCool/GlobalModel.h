//
//  GlobalModel.h
//  LittleCool
//
//  Created by 周博 on 2017/5/19.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

/*
 "background-color" = "#FFFFFFFF";
 "background-image" = "";
 created = "2017-05-08 13:51:02";
 "effect-image" = "<null>";
 height = 2208;
 id = 5;
 "material_id" = 6702;
 scale = "";
 type = poster;
 width = 1242;
 */

#import "BaseModel.h"

@interface GlobalModel : BaseModel
@property (nonatomic,strong) NSString *backgroundColor;
@property (nonatomic,strong) NSString *backgroundImage;
@property (nonatomic,strong) NSString *created;
@property (nonatomic,strong) NSString *effectImage;
@property (nonatomic,strong) NSString *height;
@property (nonatomic,strong) NSString *id;
@property (nonatomic,strong) NSString *material_id;
@property (nonatomic,strong) NSString *scale;
@property (nonatomic,strong) NSString *type;
@property (nonatomic,strong) NSString *width;


@end
