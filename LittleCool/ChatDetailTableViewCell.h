//
//  ChatDetailTableViewCell.h
//  Qian
//
//  Created by 周博 on 17/2/10.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatModel.h"

@interface ChatDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutViewHeight;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewHeader;

@property (weak, nonatomic) IBOutlet UIView *viewContent;

- (void)showDataWithModel:(ChatModel *)model;

- (CGFloat)cellHeight;
@end
