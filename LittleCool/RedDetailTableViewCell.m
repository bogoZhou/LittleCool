//
//  RedDetailTableViewCell.m
//  Qian
//
//  Created by 周博 on 17/3/9.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "RedDetailTableViewCell.h"

@implementation RedDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _imageViewHeader.layer.masksToBounds = YES;
    _imageViewHeader.layer.cornerRadius = kButtonCornerRadius;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
