//
//  BGNotiView.m
//  LittleCool
//
//  Created by 周博 on 2017/4/19.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "BGNotiView.h"
#import "BGTextView.h"

@interface BGNotiView ()
{
    
}
@property (nonatomic,strong) UIView *centerView;
@end

@implementation BGNotiView

+ (BGNotiView *)defaultManager{
        BGNotiView * defaultManager = [[BGNotiView allocWithZone:NULL] init];
        return defaultManager;
}

//- (instancetype)initWithFrame:(CGRect)frame contentText:(NSString *)contentText direction:(direction)direction
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        [self creatNotiView:direction contentText:contentText];
//    }
//    return self;
//}

- (void)showNotiViewByFrame:(CGRect)frame contentText:(NSString *)contentText direction:(direction)direction inVC:(UIViewController *)VC{
    self.frame = frame;
    [self creatNotiView:direction contentText:contentText inVC:VC];
}

- (void)creatNotiView:(direction)directionType contentText:(NSString *)contentText inVC:(UIViewController *)VC{
    
    //kuan 6
    
    NSString *showValue = kShowHelper;
    if (showValue.integerValue > 0) {
        return;
    }
    
    _centerView = [[UIView alloc] initWithFrame:CGRectMake(5, 5, self.sizeWidth - 10, self.sizeHeight - 10)];
    _centerView.layer.masksToBounds = YES;
    _centerView.layer.cornerRadius = 10;
    _centerView.backgroundColor = [kColorFrom0x(0x686f79) colorWithAlphaComponent:0.95];
    
    BGTextView *textView = [[BGTextView alloc] initWithFrame:CGRectMake(5, 0, _centerView.sizeWidth - 8, _centerView.sizeHeight - 8)];
    textView.text = contentText;
    textView.textViewTextColor = kWhiteColor;
    textView.textFont = [UIFont systemFontOfSize:16];
    textView.backgroundColor = kClearColor;
    [textView updateInfo];
    textView.selectable = NO;
    textView.placeholderStr = @"";
    [_centerView addSubview:textView];
    
    UIImageView *singleImageView = [[UIImageView alloc] init];
    
    if (directionType == up) {
        singleImageView.image = [UIImage imageNamed:@"up.png"];
        singleImageView.frame = CGRectMake((self.sizeWidth-10)/2, 0, 10, 6);
    }else if (directionType == left){
        singleImageView.image = [UIImage imageNamed:@"left.png"];
        singleImageView.frame = CGRectMake(0, (self.sizeHeight-10)/2, 6, 10);
    }else if (directionType == down){
        singleImageView.image = [UIImage imageNamed:@"down.png"];
        singleImageView.frame = CGRectMake((self.sizeWidth-10)/2, self.sizeHeight - 6, 10, 6);
    }else{
        singleImageView.image = [UIImage imageNamed:@"right.png"];
        singleImageView.frame = CGRectMake(self.sizeWidth - 6, (self.sizeHeight-10)/2, 6, 10);
    }
    [self addSubview:singleImageView];
    [self addSubview:_centerView];
    
//    [[UIApplication sharedApplication].windows.lastObject addSubview:self];
    [VC.view addSubview:self];
    [self showView];
}

- (void)showView{
    [UIView animateWithDuration:2.f animations:^{
        self.alpha = 0.9;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
