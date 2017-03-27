//
//  BGCollectionViewCell.m
//  LittleCool
//
//  Created by 周博 on 17/3/13.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "BGCollectionViewCell.h"

@implementation BGCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _imageViewImg.layer.masksToBounds = YES;
    _imageViewImg.layer.cornerRadius = kButtonCornerRadius * 2;
}

@end
