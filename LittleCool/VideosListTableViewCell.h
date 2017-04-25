//
//  VideosListTableViewCell.h
//  LittleCool
//
//  Created by 周博 on 17/3/14.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideosListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageViewHeader;

@property (weak, nonatomic) IBOutlet UILabel *labelTitle;

@property (weak, nonatomic) IBOutlet UILabel *labelDate;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewSelect;


@end
