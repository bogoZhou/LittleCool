//
//  AddView.m
//  Qian
//
//  Created by 周博 on 17/2/9.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "AddView.h"

@implementation AddView

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    
    //入口
    [self UISetting];
}

- (void)UISetting{
    _viewAll.layer.cornerRadius = 2;
}

@end
