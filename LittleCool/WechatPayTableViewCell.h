//
//  WechatPayTableViewCell.h
//  Qian
//
//  Created by 周博 on 17/3/11.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WechatPayTableViewCell : UITableViewCell

- (void)showDataWithModel:(WechatPayModel *)model;

- (CGFloat)cellHeight;

@end
