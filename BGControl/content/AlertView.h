//
//  AlertView.h
//  AlertView
//
//  Created by 郝鹏飞 on 15/12/9.
//  Copyright © 2015年 郝鹏飞. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AlertView;
typedef NS_ENUM(NSInteger,kAlertViewStyle) {
    kAlertViewStyleSuccess,
    kAlertViewStyleFail,
    kAlertViewStyleWarn,
};

typedef NS_ENUM(NSInteger,kAlerViewShowTime) {
    kAlerViewShowTimeDefault, //默认三秒
    kAlerViewShowTimeOneSecond,
    kAlerViewShowTimeTwoSeconds,
};

@protocol AlertViewDelegate <NSObject>

- (void)alertView:(AlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

@interface AlertView : UIView

@property (nonatomic,strong)id<AlertViewDelegate> delegate;

- (instancetype)initWithTitle:(NSString *)title target:(id<AlertViewDelegate>)delegate style:(kAlertViewStyle)kAlertViewStyle buttonsTitle:(NSArray *)titles;

- (instancetype)initWithTitle:(NSString *)title style:(kAlertViewStyle)kAlertViewStyle showTime:(kAlerViewShowTime)time;

- (void)showInView:(UIView *)superView;
@end
