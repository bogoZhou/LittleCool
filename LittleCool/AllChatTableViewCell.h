//
//  AllChatTableViewCell.h
//  Qian
//
//  Created by 周博 on 17/2/20.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfoModel.h"
#import "ChatModel.h"


@interface AllChatTableViewCell : UITableViewCell




- (void)showDataWithModel:(ChatModel *)model;

- (CGFloat)height;

@end
