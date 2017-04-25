//
//  BGShareHelper.h
//  LittleCool
//
//  Created by 周博 on 17/4/10.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BGShareHelper : NSObject<UIActivityItemSource>
-(instancetype)initWithData:(UIImage*)img andFile:(NSURL*)file;

@property (nonatomic, strong) UIImage *img;
@property (nonatomic, strong) NSURL *path;

+ (void)shareWeChatByController:(UIViewController *)controller imageArray:(NSArray *)array;
@end
