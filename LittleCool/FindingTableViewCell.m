//
//  FindingTableViewCell.m
//  Qian
//
//  Created by 周博 on 17/2/7.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "FindingTableViewCell.h"

@implementation FindingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _imageViewRed.layer.masksToBounds = YES;
    _imageViewRed.layer.cornerRadius = _imageViewRed.frame.size.height/2;
    _imageViewRed.backgroundColor = [UIColor redColor];
    
    _imageViewHeader.layer.masksToBounds = YES;
//    _imageViewHeader.contentMode = UIViewContentModeScaleAspectFit;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
