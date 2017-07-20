//
//  ImageelementModel.h
//  LittleCool
//
//  Created by 周博 on 2017/5/19.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

/*
 "border-color" = "";
 "border-radius" = 0px;
 "border-width" = 0px;
 category = "";
 created = "2017-05-08 13:51:03";
 "filling-image" = "";
 frame = "545px,883px,617px,813px";
 id = 5;
 "is-qrcode" = 0;
 "material_id" = 6702;
 "overlap-image" = "https://st0.dancf.com/www/15018/design/20170328-114012-7.png";
 "share-photo" = 0;
 "specially-effect" = 0;
 "z-index" = 2;
 */

#import "BaseModel.h"

@interface ImageelementModel : BaseModel
@property (nonatomic,strong) NSString *borderColor;
@property (nonatomic,strong) NSString *borderRadius;
@property (nonatomic,strong) NSString *borderWidth;
@property (nonatomic,strong) NSString *category;
@property (nonatomic,strong) NSString *created;
@property (nonatomic,strong) NSString *fillingImage;
@property (nonatomic,strong) NSString *frame;
@property (nonatomic,strong) NSString *id;
@property (nonatomic,strong) NSString *isQrcode;
@property (nonatomic,strong) NSString *material_id;
@property (nonatomic,strong) NSString *overlapImage;
@property (nonatomic,strong) NSString *sharePhoto;
@property (nonatomic,strong) NSString *speciallyEffect;
@property (nonatomic,strong) NSString *zIndex;

@end
