//
//  BGDefinitionFun.h
//  BGBanner
//
//  Created by 周博 on 16/8/29.
//  Copyright © 2016年 BogoZhou. All rights reserved.
//


//=====================获取颜色方法==============================
#pragma mark - colorFun

//参数形式0x......
#define kColorFrom0x(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//传入RGB 和 alpha
#define kColorRGB(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]

//产生随机颜色
#define kRandomColor [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1]

//=====================获取系统信息==============================
#pragma mark - 获取系统信息

//获取系统版本号
#define kSystemNo            [[[UIDevice currentDevice] systemVersion] floatValue]

//获取app版本号
#define kAppVersion          [[NSBundle mainBundle]infoDictionary][@"CFBundleShortVersionString"]

//获取 version 版本号
#define kSoftwareVersion [NSString stringWithFormat:@"%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]]

//获取手机名称
#define kDeviceName          [[UIDevice currentDevice]name]//手机名

//获取设备地址
#define kIP                  [HHUtility deviceIPAdress]


//=====================获取页面信息==============================
#pragma mark - 获取页面信息
//获取window最上层页面
#define kWindowLastPage [UIApplication sharedApplication].windows.lastObject



//=====================常用辅助方法==============================
#pragma mark - 常用辅助方法
//弹出LYMessage信息弹窗
#define kAlert(str) [BGControl Alert:(str)];

