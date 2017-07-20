//
//  TextelementModel.h
//  LittleCool
//
//  Created by 周博 on 2017/5/19.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

/*
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
 */

#import "BaseModel.h"

@interface TextelementModel : BaseModel
@property (nonatomic,strong) NSString *autoSize;
@property (nonatomic,strong) NSString *category;
@property (nonatomic,strong) NSString *content;
@property (nonatomic,strong) NSString *contentInset;
@property (nonatomic,strong) NSString *created;
@property (nonatomic,strong) NSString *fontColor;
@property (nonatomic,strong) NSString *fontName;
@property (nonatomic,strong) NSString *fontSize;
@property (nonatomic,strong) NSString *frame;
@property (nonatomic,strong) NSString *id;
@property (nonatomic,strong) NSString *kernSpacing;
@property (nonatomic,strong) NSString *lineHeight;
@property (nonatomic,strong) NSString *lineSpacing;
@property (nonatomic,strong) NSString *material_id;
@property (nonatomic,strong) NSString *sequence;
@property (nonatomic,strong) NSString *textAlign;
@property (nonatomic,strong) NSString *verticalAlign;
@property (nonatomic,strong) NSString *writingMode;
@property (nonatomic,strong) NSString *zIndex;

@end
