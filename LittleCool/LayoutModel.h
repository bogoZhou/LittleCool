//
//  LayoutModel.h
//  LittleCool
//
//  Created by 周博 on 2017/5/19.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//
/*
 "background-color" = "#FFFFFFFF";
 "background-image" = "";
 "background-repeat" = 0;
 created = "2017-05-08 13:51:02";
 */
#import "BaseModel.h"

@interface LayoutModel : BaseModel
@property (nonatomic,strong) NSString *backgroundColor;
@property (nonatomic,strong) NSString *backgroundImage;
@property (nonatomic,strong) NSString *backgroundRepeat;
@property (nonatomic,strong) NSString *created;
@property (nonatomic,strong) NSArray *fixedelement;
@property (nonatomic,strong) NSString *height;
@property (nonatomic,strong) NSString *id;
@property (nonatomic,strong) NSArray *imageelement;
@property (nonatomic,strong) NSString *material_id;
@property (nonatomic,strong) NSString *num;
@property (nonatomic,strong) NSArray *textelement;
@property (nonatomic,strong) NSString *width;

@end
