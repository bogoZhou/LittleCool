//
//  ChatDetailTableViewCell1.m
//  Qian
//
//  Created by 周博 on 17/2/10.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "ChatDetailTableViewCell1.h"
#import "JTSTextView.h"

@interface ChatDetailTableViewCell1 ()
@property (nonatomic,strong) JTSTextView *textView;

@end

@implementation ChatDetailTableViewCell1

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _imageViewHeader.backgroundColor = kWhiteColor;
    _viewContent.layer.cornerRadius = 5;
    _viewContent.layer.borderWidth = 0.5;
    _viewContent.layer.borderColor = [kColorFrom0x(0x82ad5b) CGColor];
}

- (void)showDataWithModel:(ChatModel *)model{
    [_textView removeFromSuperview];
    
//    NSDictionary *attrs = @{NSFontAttributeName : [UIFont systemFontOfSize:16]};
//    CGSize size=[model.content sizeWithAttributes:attrs];
//
//    CGSize size2= [BGControlHelper labelAutoCalculateRectWith:model.content FontSize:16 MaxSize:CGSizeMake(kScreenSize.width - 120 - 20, 1000)];
//    if (size2.width < _layoutViewWidth.constant) {
//        _layoutViewWidth.constant = size.width;
//    }
//
//    [self updateConstraints];
//    _layoutViewWidth.constant = size.width;
//    UIImage *image = [[UIImage alloc]init];
    
    
    
    _textView = [[JTSTextView alloc] initWithFrame:CGRectMake(10, 5, kScreenSize.width - 120, 30) fontSize:16];
//    _textView.textAlignment = NSTextAlignmentRight;
    [_viewContent addSubview:_textView];
    _textView.tintColor = kWechatBlack;
    _textView.scrollEnabled = NO;
    CGFloat height = [BGControlHelper textHeightFromTextString:model.content width: _textView.frame.size.width fontSize:16];

    if (height < 20) {
        _layoutViewHeight.constant = 39;
    }else{
        _layoutViewHeight.constant = height + 20;
    }
    
    _textView.editable = NO;
    _textView.backgroundColor = kClearColor;
    [_textView setKeyboardType:UIKeyboardTypeDefault];
    NSString *value = model.content;
    [self.textView setText:value];
}


- (CGFloat)cellHeight{
    CGFloat height = [BGControlHelper textHeightFromTextString:_textView.text width:_textView.frame.size.width fontSize:16];
    if (height < 20) {
        return 39;
    }else{
        return height + 20;
    }
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
