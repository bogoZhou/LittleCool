//
//  BorderHelper.h
//  Qian
//
//  Created by 周博 on 17/2/8.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BorderHelper : NSObject

+ (BorderHelper *)defaultManager;

+ (void)setBorderWithColor:(UIColor *)color button:(UIButton *)button;

+ (void)setBorderWithColor:(UIColor *)color view:(UIView *)view;

+ (void)setOnlyUnderLineColor:(UIColor *)color view:(UIView *)view;
@end
