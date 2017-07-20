//
//  PosterDetailModel.h
//  LittleCool
//
//  Created by 周博 on 2017/5/19.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

/*
 global =         {
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
 };
 layout =         {
 "background-color" = "#FFFFFFFF";
 "background-image" = "";
 "background-repeat" = 0;
 created = "2017-05-08 13:51:02";
 fixedelement =             (
 {
 "background-image" = "https://st0.dancf.com/www/15018/design/20170328-114012-6.jpg";
 category = "";
 created = "2017-05-08 13:51:03";
 frame = "0px,0px,1242px,2208px";
 id = 5;
 "is-gif" = 0;
 "is-logo" = 0;
 "material_id" = 6702;
 "z-index" = 1;
 }
 );
 height = 2208;
 id = 5;
 imageelement =             (
 {
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
 }
 );
 "material_id" = 6702;
 num = 1;
 textelement =             (
 {
 "auto-size" = 1;
 category = "";
 content = "\U5927\U9519\U7279\U9519!";
 "content-inset" = "0px,0px,0px,0px";
 created = "2017-05-08 13:51:03";
 "font-color" = "#BD1921FF";
 "font-name" = SiC;
 "font-size" = 144px;
 frame = "179px,423px,948px,175px";
 id = 5;
 kernSpacing = 0px;
 "line-height" = "1.2";
 lineSpacing = 10px;
 "material_id" = 6702;
 sequence = "";
 "text-align" = left;
 "vertical-align" = center;
 "writing-mode" = "lr-tb";
 "z-index" = 3;
 }
 );
 width = 1242;
 };
 };

 */

#import "BaseModel.h"
#import "GlobalModel.h"
#import "LayoutModel.h"
#import "FixedelementModel.h"
#import "ImageelementModel.h"
#import "TextelementModel.h"

@interface PosterDetailModel : BaseModel
@property (nonatomic,strong) GlobalModel *global;
@property (nonatomic,strong) LayoutModel *layout;
@end
