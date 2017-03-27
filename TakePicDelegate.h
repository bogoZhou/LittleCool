//
//  TakePicDelegate.h
//  SuperStudent_Teacher
//
//  Created by 周博 on 16/5/11.
//  Copyright © 2016年 BogoZhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TakePicDelegate : NSObject
{
    
}

+ (TakePicDelegate *)defaultManager;

@property (nonatomic,strong) UIViewController *mainController;

- (void)jumpAlarmInViewController:(UIViewController *)VC notiName:(NSString *)notiName;

-(void)takePhoto;

-(void)LocalPhoto;

- (void)setMainController:(UIViewController *)mainController notiName:(NSString *)notiName;
@end
