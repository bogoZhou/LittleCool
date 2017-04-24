//
//  ChatTableViewCell.h
//  Qian
//
//  Created by 周博 on 17/2/7.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageViewHeader;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelContent;
@property (weak, nonatomic) IBOutlet UILabel *labelTime;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewLingdang;
@property (weak, nonatomic) IBOutlet UILabel *labelRed;

@end
