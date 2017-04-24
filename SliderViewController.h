//
//  SliderViewController.h
//  Qian
//
//  Created by 周博 on 17/2/22.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BGSliderHelper : NSObject

@property (nonatomic,copy) void(^actionHandler)(BGSliderHelper * action);

@property (nonatomic,strong) NSString *titleS;

+ (instancetype)actionWithTitle:(NSString *)titleStr handler:(void (^)(BGSliderHelper *action))handler;

@end

@interface SliderViewController : UIViewController

@property (nonatomic, readonly) BGSliderHelper *action;

- (void)addAction:(BGSliderHelper *)action;

@end
