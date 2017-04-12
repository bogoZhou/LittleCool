//
//  VideosModel.h
//  LittleCool
//
//  Created by 周博 on 17/3/14.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "BaseModel.h"


/**
 {
 "id": "1005",    //视频id
 "label_id": "34",   //标签id
 "title": "白云机场",   //视频名字
 "introduce": "来个360度的旋转拍摄，我就是出来冒下泡。我下飞机了！", //视频简介
 "img_url": null,    //图片地址
 "video_url": "http://oj09diuk4.bkt.clouddn.com/%E7%99%BD%E4%BA%91%E6%9C%BA%E5%9C%BA.mp4",   //视频播放地址
 "vip_grade": "0",
 "status": "1",
 "created": "2017-02-28 14:44:09"
 }

 */
@interface VideosModel : BaseModel
@property (nonatomic,strong) NSString *id;
@property (nonatomic,strong) NSString *label_id;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *introduce;
@property (nonatomic,strong) NSString *img_url;
@property (nonatomic,strong) NSString *video_url;
@property (nonatomic,strong) NSString *vip_grade;
@property (nonatomic,strong) NSString *status;
@property (nonatomic,strong) NSString *created;
@property (nonatomic,strong) NSString *url;
@property (nonatomic,strong) NSURL *localUrl;
@property (nonatomic,strong) NSString *statusNew;
@end
