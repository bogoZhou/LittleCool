//
//  BGCollectionViewCell.h
//  LittleCool
//
//  Created by 周博 on 17/3/13.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BGCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIView *bgContentView;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewImg;

@property (weak, nonatomic) IBOutlet UILabel *labelName;

@end
