//
//  NewMainViewController.h
//  LittleCool
//
//  Created by 周博 on 17/4/10.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "BaseViewController.h"
#import <ImagePlayerView.h>

@interface NewMainViewController : BaseViewController

@property (weak, nonatomic) IBOutlet ImagePlayerView *viewBanner;

@property (weak, nonatomic) IBOutlet UIView *viewSounds;
@property (weak, nonatomic) IBOutlet UIView *centerViewSounds;


@property (weak, nonatomic) IBOutlet UIView *viewImage;
@property (weak, nonatomic) IBOutlet UIView *centerViewImage;

@property (weak, nonatomic) IBOutlet UIView *viewCoolImage;
@property (weak, nonatomic) IBOutlet UIView *centerViewCoolImage;


@end
