//
//  RedDetailTableViewCell.h
//  Qian
//
//  Created by 周博 on 17/3/9.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RedDetailTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageViewHeader;

@property (weak, nonatomic) IBOutlet UILabel *labelName;

@property (weak, nonatomic) IBOutlet UILabel *labelDate;

@property (weak, nonatomic) IBOutlet UILabel *labelMoney;

@property (weak, nonatomic) IBOutlet UIView *viewBest;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewTopView;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewDeepLong;

@property (weak, nonatomic) IBOutlet UIImageView *imaegViewDeepShort;
@end
