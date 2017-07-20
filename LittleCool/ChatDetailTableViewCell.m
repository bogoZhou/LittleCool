//
//  ChatDetailTableViewCell.m
//  Qian
//
//  Created by 周博 on 17/2/10.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "ChatDetailTableViewCell.h"
#import "JTSTextView.h"

@interface ChatDetailTableViewCell ()
{
    
}
@property (nonatomic,strong) JTSTextView *textView;
@end

@implementation ChatDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _imageViewHeader.backgroundColor = kWhiteColor;
    _viewContent.layer.cornerRadius = 5;
    _viewContent.layer.borderWidth = 0.5;
    _viewContent.layer.borderColor = [kColorFrom0x(0xcdcdcd) CGColor];
}

- (void)showDataWithModel:(ChatModel *)model{
    [_textView removeFromSuperview];
    _textView = [[JTSTextView alloc] initWithFrame:CGRectMake(10, 8, kScreenSize.width - 60, 30) fontSize:16];
    [_viewContent addSubview:_textView];
    _textView.tintColor = kWechatBlack;
    _textView.scrollEnabled = NO;
    CGFloat height = [BGControlHelper textHeightFromTextString:model.content width:kScreenSize.width - 60 fontSize:16];
    
    if (height < 20) {
        _layoutViewHeight.constant = 40;
    }else{
        _layoutViewHeight.constant = height;
    }
    
    _textView.editable = NO;
    _textView.backgroundColor = kClearColor;
    [_textView setKeyboardType:UIKeyboardTypeDefault];
    NSString *value = model.content;
    [self.textView setText:value];
}

- (CGFloat)cellHeight{
    CGFloat height = [BGControlHelper textHeightFromTextString:_textView.text width:170 fontSize:16];
    if (height < 20) {
        return 35;
    }else{
        return height;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
