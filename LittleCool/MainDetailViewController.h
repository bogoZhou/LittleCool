//
//  MainDetailViewController.h
//  LittleCool
//
//  Created by 周博 on 17/3/13.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "BaseViewController.h"
#import "VideosModel.h"

@interface MainDetailViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UIView *viewAudio;

@property (weak, nonatomic) IBOutlet UILabel *labelAudioName;

@property (weak, nonatomic) IBOutlet UILabel *labelAudioContent;

@property (weak, nonatomic) IBOutlet UIView *viewIWantoP;

@property (weak, nonatomic) IBOutlet UIView *viewBeginP;

@property (nonatomic,strong)  VideosModel *model;

@property (weak, nonatomic) IBOutlet UIButton *listenButton;

@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@property (weak, nonatomic) IBOutlet UIButton *beginButton;

@property (weak, nonatomic) IBOutlet UILabel *labelPeiyin;

@property (weak, nonatomic) IBOutlet UIView *viewSlider;

@property (weak, nonatomic) IBOutlet UISlider *sliderOne;

@property (weak, nonatomic) IBOutlet UISlider *sliderTwo;

@property (weak, nonatomic) IBOutlet UIButton *buttonWaterMark;

@property (weak, nonatomic) IBOutlet UILabel *labelShiting;

@property (weak, nonatomic) IBOutlet UILabel *labelShanchu;
@end
