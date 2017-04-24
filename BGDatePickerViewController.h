//
//  BGDatePickerViewController.h
//  Qian
//
//  Created by 周博 on 17/2/22.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BGDatePickerAction :NSObject

@property (nonatomic,copy) void(^actionHandler)(BGDatePickerAction * action);

@property (nonatomic,strong) NSString *titleS;

+ (instancetype)actionWithTitle:(NSString *)titleStr handler:(void (^)(BGDatePickerAction *action))handler;

@end

@interface BGDatePickerViewController : UIViewController

@property (nonatomic, readonly) BGDatePickerAction *action;

- (void)addAction:(BGDatePickerAction *)action;

@end
