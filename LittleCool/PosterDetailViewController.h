//
//  PosterDetailViewController.h
//  LittleCool
//
//  Created by 周博 on 2017/5/18.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "PosterBaseViewController.h"
#import "PosterDetailModel.h"

@interface PosterDetailViewController : PosterBaseViewController

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic,strong) PosterDetailModel *posterDetailModel;

@end

