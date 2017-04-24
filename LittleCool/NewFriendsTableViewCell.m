//
//  NewFriendsTableViewCell.m
//  Qian
//
//  Created by 周博 on 17/3/6.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "NewFriendsTableViewCell.h"
#import "BorderHelper.h"

@implementation NewFriendsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)showDataWithModel:(loadUserModel *)user{
    _imageViewHeader.layer.masksToBounds = YES;
    _imageViewHeader.contentMode = UIViewContentModeScaleAspectFill;
    [_imageViewHeader sd_setImageWithURL:[NSURL URLWithString:user.img_url]];
    
    _labelName.font = [UIFont fontWithName:kChatFont size:16];
    _labelName.text = user.name;
    
    _labelIamName.font = [UIFont fontWithName:kChatFont size:14];
    _labelIamName.text = [NSString stringWithFormat:@"我是%@",user.name];
    
    _buttonGet.layer.masksToBounds = YES;
    _buttonGet.layer.cornerRadius = kButtonCornerRadius;
    _buttonGet.layer.borderColor = [kChatGreenBorder CGColor];
    _buttonGet.layer.borderWidth = 0.5f;
    
    if (user.type.integerValue > 0) {
        _labelHasGotton.hidden = YES;
        _buttonGet.hidden = NO;
    }else{
        _labelHasGotton.hidden = NO;
        _buttonGet.hidden = YES;
    }
    
}


//点击接受
- (IBAction)getButtonClick:(UIButton *)sender {
//    NSLog(@"tag -> %ld",sender.tag);
    NSString * indexRow = [NSString stringWithFormat:@"%ld",sender.tag];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"allowFriends" object:indexRow];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
