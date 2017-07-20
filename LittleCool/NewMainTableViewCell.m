//
//  NewMainTableViewCell.m
//  LittleCool
//
//  Created by 周博 on 2017/4/25.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "NewMainTableViewCell.h"

@implementation NewMainTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)UISettingByColor:(UIColor *)color title:(NSString *)title image:(UIImage *)image{
    
    CGFloat alf = 0.7;
    _viewCenter.layer.masksToBounds = YES;
    _viewCenter.layer.cornerRadius = 5;
    _viewCenter.backgroundColor = color;
    _viewContent.backgroundColor = [color colorWithAlphaComponent:alf];
    _imageViewHeader.image = image;
    _imageViewHeader.layer.masksToBounds = YES;
    _imageViewHeader.contentMode = UIViewContentModeScaleAspectFit;
    _labelTitle.text = title;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
