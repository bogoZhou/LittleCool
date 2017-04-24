//
//  ChatTableViewCell.m
//  Qian
//
//  Created by 周博 on 17/2/7.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "ChatTableViewCell.h"

@implementation ChatTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _imageViewHeader.layer.masksToBounds = YES;
    _imageViewHeader.layer.cornerRadius = 5;
    _imageViewHeader.backgroundColor = kWhiteColor;
    
    _labelRed.layer.masksToBounds = YES;
    _labelRed.layer.cornerRadius = _labelRed.frame.size.height/2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
