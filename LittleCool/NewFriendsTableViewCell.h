//
//  NewFriendsTableViewCell.h
//  Qian
//
//  Created by 周博 on 17/3/6.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "loadUserModel.h"

@interface NewFriendsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageViewHeader;

@property (weak, nonatomic) IBOutlet UILabel *labelName;

@property (weak, nonatomic) IBOutlet UILabel *labelIamName;

@property (weak, nonatomic) IBOutlet UIButton *buttonGet;

@property (weak, nonatomic) IBOutlet UILabel *labelHasGotton;

- (void)showDataWithModel:(loadUserModel *)user;
@end
