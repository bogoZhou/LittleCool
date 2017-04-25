//
//  BannerModel.h
//  LittleCool
//
//  Created by 周博 on 17/4/11.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

/*
 created = "2017-04-10 17:04:15";
 id = 1;
 "img_url" = "http://139.196.18.81/file/33d117e4ff22020ceaf6b17dad7db525.png";
 "redirect_link" = "http://www.baidu.com";
 sort = 1;
 status = 1;
 */
#import "BaseModel.h"

@interface BannerModel : BaseModel
@property (nonatomic,strong) NSString *created;
@property (nonatomic,strong) NSString *id;
@property (nonatomic,strong) NSString *img_url;
@property (nonatomic,strong) NSString *redirect_link;
@property (nonatomic,strong) NSString *sort;
@property (nonatomic,strong) NSString *status;

@end
