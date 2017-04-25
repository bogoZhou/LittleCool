//
//  JumpAnimation.h
//  SuperStudent
//
//  Created by 周博 on 16/3/24.
//  Copyright © 2016年 BogoZhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JumpAnimation : NSObject
@property (nonatomic,strong) CALayer *dotLayer;

@property (nonatomic,strong) UIView *aniView;

@property (nonatomic,assign) CGFloat endPointX;

@property (nonatomic,assign) CGFloat endPointY;

@property (nonatomic,assign) CGFloat changePointX;

@property (nonatomic,assign) CGFloat changePointY;

@property (nonatomic,strong) UIBezierPath *path;

@property (nonatomic,strong) UIView *endView;

@property (nonatomic,assign) CGRect labelFrame;

@property (nonatomic) BOOL isExerciseVC;
-(void) JoinCartAnimationWithRect:(CGRect)rect superView:(UIView *)superView jumpView:(UIView *)jumpView;
@end
