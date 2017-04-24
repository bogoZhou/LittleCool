//
//  BGNotiView.h
//  LittleCool
//
//  Created by 周博 on 2017/4/19.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BGNotiView : UIView

typedef enum {
    up=0,
    left,
    down,
    right
} direction;

+ (BGNotiView *)defaultManager;


@property (nonatomic,assign) NSInteger directionType;

//- (instancetype)initWithFrame:(CGRect)frame contentText:(NSString *)contentText direction:(direction)direction;

- (void)showNotiViewByFrame:(CGRect)frame contentText:(NSString *)contentText direction:(direction)direction inVC:(UIViewController *)VC;

@end
