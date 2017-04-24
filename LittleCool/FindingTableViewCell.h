//
//  FindingTableViewCell.h
//  Qian
//
//  Created by 周博 on 17/2/7.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FindingTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageViewHeader;

@property (weak, nonatomic) IBOutlet UILabel *labelName;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewTop;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewDown0;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewDown1;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewNews;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewRed;

@end
