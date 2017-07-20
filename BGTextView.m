//
//  BGTextView.m
//  BGTextViewDemo
//
//  Created by 周博 on 16/12/30.
//  Copyright © 2016年 BogoZhou. All rights reserved.
//

#import "BGTextView.h"

@interface BGTextView ()<UITextViewDelegate>
{
    
}
@property (nonatomic,strong) UILabel *placeholderLabel;
@end

@implementation BGTextView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _viewFrame = frame;
        [self setDefaultInfo];
        [self creatPlaceholderLabel];
    }
    return self;
}

- (void)setDefaultInfo{
    _placeholderStr = @"";
    
    _placeholderColor = [UIColor groupTableViewBackgroundColor];
    
    _textFontSize = 17;
    
    _textFont = [UIFont fontWithName:@"PingFangTC-Light" size:_textFontSize];
    
    _textViewTextColor = [UIColor blackColor];
}


- (void)creatPlaceholderLabel{
    if (!_placeholderLabel) {
        _placeholderLabel = [[UILabel alloc] init];
        [self addSubview:_placeholderLabel];
    }
    
    _placeholderLabel.frame = CGRectMake(7, 10, self.frame.size.width - 10, 20);
    
    _placeholderLabel.text = _placeholderStr;
    
    _placeholderLabel.textColor = _placeholderColor;
    
    _placeholderLabel.font = _textFont;
    
    
    
    self.textColor = _textViewTextColor;
    
    self.font = _textFont;
    
    self.tintColor = _textViewTextColor;
    
    self.frame = _viewFrame;
    
    self.delegate = self;
}

- (void)updateInfo{
    [self creatPlaceholderLabel];
}

-(void)textViewDidChange:(UITextView *)textView{
    if (textView == nil || textView.text.length == 0 || [textView.text isEqualToString:@""]) {
        _placeholderLabel.hidden = NO;
    }else{
        _placeholderLabel.hidden = YES;
    }
}

@end
