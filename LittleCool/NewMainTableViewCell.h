//
//  NewMainTableViewCell.h
//  LittleCool
//
//  Created by 周博 on 2017/4/25.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewMainTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *viewContent;

@property (weak, nonatomic) IBOutlet UIView *viewCenter;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewHeader;

@property (weak, nonatomic) IBOutlet UILabel *labelTitle;

- (void)UISettingByColor:(UIColor *)color title:(NSString *)title image:(UIImage *)image;
@end
