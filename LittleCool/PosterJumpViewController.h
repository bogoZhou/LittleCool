//
//  PosterJumpViewController.h
//  LittleCool
//
//  Created by 周博 on 2017/5/16.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "PosterBaseViewController.h"

#import "PosterListModel.h"

#import "MubanModel.h"

@interface PosterJumpViewController : PosterBaseViewController

@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewCenter;

@property (weak, nonatomic) IBOutlet UIView *scrollViewCenterView;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewInScroll;

@property (weak, nonatomic) IBOutlet UIButton *ButtonUse;

@property (weak, nonatomic) IBOutlet UIButton *buttonBack;

@property (nonatomic,strong) MubanModel *mubanModel;


@end
