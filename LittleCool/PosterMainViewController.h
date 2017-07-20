//
//  PosterMainViewController.h
//  LittleCool
//
//  Created by 周博 on 2017/4/25.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "PosterBaseViewController.h"

@interface PosterMainViewController : PosterBaseViewController

@property (weak, nonatomic) IBOutlet UIView *viewTuijian;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewTuijian;
@property (weak, nonatomic) IBOutlet UILabel *labelTuijian;

@property (weak, nonatomic) IBOutlet UIView *viewQuanbu;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewQuanbu;
@property (weak, nonatomic) IBOutlet UILabel *labelQuanbu;

@property (weak, nonatomic) IBOutlet UITableView *tableView;



@end
