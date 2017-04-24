//
//  BGItemsViewController.h
//  JumpViewItemsDemo
//
//  Created by 周博 on 16/12/22.
//  Copyright © 2016年 BogoZhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BGItemsAction : NSObject

@property (nonatomic,copy) void(^actionHandler)(BGItemsAction * action);

@property (nonatomic,strong) NSString *titleS;

+ (instancetype)actionWithTitle:(NSString *)titleStr handler:(void (^)(BGItemsAction *action))handler;

@end

@interface BGItemsViewController : UIViewController
{
    
}
@property (nonatomic, readonly) NSArray<BGItemsAction*> *actions;

@property (nonatomic,strong) UIView *superV;
@property (nonatomic,assign) CGFloat itemsWidth;

+ (instancetype)viewWithFrameBySuperView:(UIView * )superView;

- (void)addActions:(BGItemsAction *)actions;

@end
