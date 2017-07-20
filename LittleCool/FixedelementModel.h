//
//  FixedelementModel.h
//  LittleCool
//
//  Created by 周博 on 2017/5/19.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

/*
 "background-image" = "https://st0.dancf.com/www/15018/design/20170328-114012-6.jpg";
 category = "";
 created = "2017-05-08 13:51:03";
 frame = "0px,0px,1242px,2208px";
 id = 5;
 "is-gif" = 0;
 "is-logo" = 0;
 "material_id" = 6702;
 "z-index" = 1;
 */

#import "BaseModel.h"

@interface FixedelementModel : BaseModel
@property (nonatomic,strong) NSString *backgroundImage;
@property (nonatomic,strong) NSString *category;
@property (nonatomic,strong) NSString *created;
@property (nonatomic,strong) NSString *frame;
@property (nonatomic,strong) NSString *id;
@property (nonatomic,strong) NSString *isGif;
@property (nonatomic,strong) NSString *isLogo;
@property (nonatomic,strong) NSString *material_id;
@property (nonatomic,strong) NSString *zIndex;
@end
