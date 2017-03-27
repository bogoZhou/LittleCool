//
//  JumpAnimation.m
//  SuperStudent
//
//  Created by 周博 on 16/3/24.
//  Copyright © 2016年 BogoZhou. All rights reserved.
//

#import "JumpAnimation.h"
#import "BGControl.h"

@implementation JumpAnimation


#pragma mark -加入购物车动画
-(void) JoinCartAnimationWithRect:(CGRect)rect superView:(UIView *)superView jumpView:(UIView *)jumpView
{
    self.aniView = jumpView;
    CGFloat startX = rect.origin.x;
    CGFloat startY = rect.origin.y;
    
    _path= [UIBezierPath bezierPath];
    [_path moveToPoint:CGPointMake(startX, startY)];
    //三点曲线
    [_path addCurveToPoint:CGPointMake(_endPointX, _endPointY)
             controlPoint1:CGPointMake(startX, startY)
             controlPoint2:CGPointMake(_endPointX - _changePointX, _endPointY - _changePointY)];
    
//    _dotLayer = [CALayer layer];
//    _dotLayer.backgroundColor = [UIColor redColor].CGColor;
//    _dotLayer.frame = CGRectMake(0, 0, 15, 15);
//    _dotLayer.cornerRadius = (15 + 15) /4;
//    [superView.layer addSublayer:_dotLayer];
    
//    self.aniView.backgroundColor = kTabBarColor;
//    self.aniView.backgroundColor = [UIColor yellowColor]
    self.aniView.layer.cornerRadius = self.aniView.frame.size.width/2;
    [superView addSubview:self.aniView];
    
    [self groupAnimation];
    
}
#pragma mark - 组合动画
-(void)groupAnimation
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = _path.CGPath;
    
    /**
     *  是否有旋转效果
     */
    animation.rotationMode = nil;
    
    
    CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"alpha"];
    alphaAnimation.duration = 0.5f;
    alphaAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    alphaAnimation.toValue = [NSNumber numberWithFloat:0.1];
    alphaAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    CAAnimationGroup *groups = [CAAnimationGroup animation];
    groups.animations = @[animation,alphaAnimation];
    groups.duration = 1.f;
    groups.removedOnCompletion = NO;
    groups.fillMode = kCAFillModeForwards;
    groups.delegate = self;
    [groups setValue:@"groupsAnimation" forKey:@"animationName"];
    [self.aniView.layer addAnimation:groups forKey:nil];
    
    [self performSelector:@selector(removeFromLayer:) withObject:self.aniView.layer afterDelay:1.f];
    
}
- (void)removeFromLayer:(CALayer *)layerAnimation{
    
//    [layerAnimation removeFromSuperlayer];
    if (_isExerciseVC) {
        [self ExaLabelJump];
    }else{
         [self labelJump];
    }
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    
    if ([[anim valueForKey:@"animationName"]isEqualToString:@"groupsAnimation"]) {
        
        CABasicAnimation *shakeAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        shakeAnimation.duration = 0.25f;
        shakeAnimation.fromValue = [NSNumber numberWithFloat:0.9];
        shakeAnimation.toValue = [NSNumber numberWithFloat:1];
        shakeAnimation.autoreverses = YES;
        [self.endView.layer addAnimation:shakeAnimation forKey:nil];
    }
    
}

- (void)labelJump{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kScreenSize.width /4*3, kScreenSize.height-40, kScreenSize.width/4, 20)];
    _labelFrame = label.frame;
    label.text = @"积分 +1";
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = kColorRGB(51, 153, 102, 1);
    label.textAlignment = NSTextAlignmentCenter;
    [[[[UIApplication sharedApplication] windows] lastObject] addSubview:label];
    
    [UIView animateWithDuration:0.8f animations:^{
        label.hidden = NO;
        CGRect farme = label.frame;
        farme = CGRectMake(_labelFrame.origin.x, _labelFrame.origin.y - 26, _labelFrame.size.width, _labelFrame.size.height);
        label.frame = farme;
    } completion:^(BOOL finished) {
        label.frame = _labelFrame;
        label.hidden = YES;
    }];

}

- (void)ExaLabelJump{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 33 , kScreenSize.width/4, 20)];
    _labelFrame = label.frame;
    label.text = @"积分 +1";
//    label.textColor = kColorRGB(51, 153, 102, 1);
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentLeft;
    [[[[UIApplication sharedApplication] windows] lastObject] addSubview:label];
    
    [UIView animateWithDuration:0.8f animations:^{
        label.hidden = NO;
        CGRect farme = label.frame;
        farme = CGRectMake(_labelFrame.origin.x + 35, _labelFrame.origin.y , _labelFrame.size.width, _labelFrame.size.height);
        label.frame = farme;
    } completion:^(BOOL finished) {
        label.frame = _labelFrame;
        label.hidden = YES;
    }];
    
}

@end
