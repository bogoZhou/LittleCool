//
//  BorderHelper.m
//  Qian
//
//  Created by 周博 on 17/2/8.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "BorderHelper.h"

static BorderHelper * defaultManager = nil;

@implementation BorderHelper

+(BorderHelper *)defaultManager{
    if (!defaultManager) {
        defaultManager = [[BorderHelper allocWithZone:NULL] init];
    }
    return defaultManager;
}

+ (void)setBorderWithColor:(UIColor *)color button:(UIButton *)button{
    button.layer.cornerRadius = kButtonCornerRadius * 2;
    button.layer.borderColor = [color CGColor];
    button.layer.borderWidth = 0.5f;
}

+ (void)setBorderWithColor:(UIColor *)color view:(UIView *)view{
    view.layer.borderColor = [color CGColor];
    view.layer.borderWidth = 0.5f;
}

+ (void)setOnlyUnderLineColor:(UIColor *)color view:(UIView *)view{
    CALayer *TopBorder = [CALayer layer];
    TopBorder.frame = CGRectMake(0.0f, view.frame.size.height-0.5, view.frame.size.width, 0.5f);
    TopBorder.backgroundColor = color.CGColor;
    [view.layer addSublayer:TopBorder];
}

@end
