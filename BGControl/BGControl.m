//
//  BGControl.m
//  MyControl
//
//  Created by chenghong_mac on 15/7/30.
//  Copyright (c) 2015年 Bogo. All rights reserved.
//

#import "BGControl.h"



@implementation BGControl
+(UILabel *)creatLabelWithFrame:(CGRect)frame text:(NSString *)text font:(UIFont *)font numberOfLine:(NSInteger)numberOfLine isLayer:(BOOL)isLayer cornerRadius:(CGFloat)cornerRadius backgroundColor:(UIColor *)backgroundColor{
    //设置label的frame
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    //设置label的内容
    label.text = text;
    //设置label的字体及大小
    label.font = font;
    //设置背景颜色
    label.backgroundColor = backgroundColor;
    //设置label显示的行数
    label.numberOfLines = numberOfLine;
    if (isLayer) {
        //设置label 角的弧度
        label.layer.masksToBounds = YES;
        label.layer.cornerRadius = cornerRadius;
    }
    return label;
}

+ (UIButton *)creatButtonWithFrame:(CGRect)frame target:(id)target sel:(SEL)sel tag:(NSInteger)tag image:(NSString *)image isBackgroundImage:(BOOL)isBackgroundImage title:(NSString *)title isLayer:(BOOL)isLayer cornerRadius:(CGFloat)cornerRadius{
    UIButton *button = nil;
    if (image) {
        if (isBackgroundImage) {
            //创建背景图片按钮
            button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
        }else{
            //创建图片按钮
            button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
        }
    }else if (title) {
        //创建标题按钮
        button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setTitle:title forState:UIControlStateNormal];
    }else{
        button = [UIButton buttonWithType:UIButtonTypeSystem];
    }
    //设置button的弧度
    if (isLayer) {
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = cornerRadius;
    }
    if (image == nil && title == nil) {
        button.backgroundColor = [UIColor clearColor];
    }
    //设置button的frame
    button.frame = frame;
    //设置 button的 tag值
    button.tag = tag;
    //button 添加点击事件
    [button addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    return button;
}


+(UIImageView *)creatImageViewWithFrame:(CGRect)frame image:(NSString *)image isWebImage:(BOOL)isWebImage holdOnImage:(NSString *)holdOnImage isLayer:(BOOL)isLayer cornerRadius:(CGFloat)cornerRadius{
    //设置 imageView 的 frame
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    //判断来源是否是网络图片
    if (isWebImage) {//加载网络图片
        [imageView sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:holdOnImage]];
       
//        NSLog(@"%@",imageView.image);
//        CGRect frame = imageView.frame;
//        frame.size = imageView.image.size;
//        imageView.frame = frame;
    }else{//加载本地图片
        imageView.image = [UIImage imageNamed:image];
    }
    //判断是否需要圆角
    if (isLayer) {
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = cornerRadius;
    }
    imageView.userInteractionEnabled = YES;
    return imageView;
}


+(UITextField *)creatTextFieldWithFrame:(CGRect)frame placeHolder:(NSString *)placeHolder borderStyle:(UITextBorderStyle)borderStyle delegate:(id<UITextFieldDelegate>)delegate tag:(NSInteger)tag{
    //设置 textField 的 frame
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    //设置 默认内容
    textField.placeholder = placeHolder;
    //设置 边框风格
    textField.borderStyle = borderStyle;
    //设置 代理
    textField.delegate = delegate;
    //设置 tag值
    textField.tag = tag;
    return textField;
}

+(UITextView *)creatTextViewWithFrame:(CGRect)frame text:(NSString *)text textAlignment:(NSTextAlignment)textAlignment textColor:(UIColor *)textColor font:(UIFont *)font isEditable:(BOOL)isEditable backgroundColor:(UIColor *)backgroundColor isLayer:(BOOL)isLayer cornerRadius:(CGFloat)cornerRadius delegate:(id<UITextViewDelegate>)delegate{
    //设置 textView 的 frame
    UITextView *textView = [[UITextView alloc] initWithFrame:frame];
    //设置 内容
    textView.text = text;
    //设置 排版类型 0->左对齐  1->居中  2->右对齐
    textView.textAlignment = textAlignment;
    //设置 字体颜色
    textView.textColor =textColor;
    //设置 字体
    textView.font = font;
    //设置 是否可编辑
    textView.editable = isEditable;
    //设置 背景颜色
    textView.backgroundColor = backgroundColor;
    //设置 圆角
    if (isLayer) {
        textView.layer.masksToBounds = YES;
        textView.layer.cornerRadius = cornerRadius;
    }
    //设置 代理
    textView.delegate = delegate;
    //设置 PlaceHolder
    /*
     -(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
     if (![text isEqualToString:@""]) {
     _text.hidden = YES;
     }
     if ([text isEqualToString:@""] && range.location == 0 && range.length == 1) {
     _text.hidden = NO;
     }
     return YES;
     }
     */
    return textView;
}

+(UIScrollView *)creatScrollViewWithFrame:(CGRect)frame dataArr:(NSArray *)dataArr delegate:(id<UIScrollViewDelegate>)delegate time:(NSTimeInterval)time target:(id)target btnSel:(SEL)btnSel timerSel:(SEL)timerSel userInfo:(id)userInfo repeats:(BOOL)repeats isLocalImage:(BOOL)isLocalImage placeHolderImage:(NSString *)placeHolderImage{
    //创建scrollView 及 frame
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:frame];
    //设置scrollView 的总长度
    scrollView.contentSize = CGSizeMake(kScreenSize.width * dataArr.count, frame.size.height);
    //设置 分成不同页面
    scrollView.pagingEnabled = YES;
    //代理
    scrollView.delegate = delegate;
    //设置是否可以左右滑动
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    //设置反弹动画
    scrollView.bounces = NO;
    //背景颜色
    scrollView.backgroundColor = [UIColor whiteColor];
    //是否 可翻页
    scrollView.delaysContentTouches = YES;
    //触摸事件
    scrollView.canCancelContentTouches = NO;
    //用户交互
    scrollView.userInteractionEnabled = YES;
    
    //循环将粘有button的imageView 粘贴到scrollView上
    for (NSInteger i = 0; i < dataArr.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * kScreenSize.width, 0, kScreenSize.width, frame.size.height)];
        if (!isLocalImage) {
            [imageView sd_setImageWithURL:[NSURL URLWithString:dataArr[i]] placeholderImage:[UIImage imageNamed:placeHolderImage]];
        }else{
            imageView.image = [UIImage imageNamed:dataArr[i]];
        }
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.tag = i+1000;
        button.frame = frame;
        [button addTarget:target action:btnSel forControlEvents:UIControlEventTouchUpInside];
        [imageView addSubview:button];
        imageView.userInteractionEnabled = YES;
        [scrollView addSubview:imageView];
    }
    
    //添加定时器
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:time target:target selector:timerSel userInfo:userInfo repeats:repeats];
    //运行定时器
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    return scrollView;
    
    //具体的点击事件内容
    /*
     - (void)buttonClick:(UIButton *)button{
     NSLog(@"被点击 %d",button.tag);
     }
     -(void)timerSelect{
     _timeCount ++;
     NSInteger count = 0;
     NSArray *array = @[@"表嫂.jpg",@"老白干.jpg",@"扫黄.jpg",@"laoda.jpg"];
     if (_change) {
     count =_timeCount% array.count;
     if (count == array.count-1) {
     _change = NO;
     }
     }else{
     count =array.count - (_timeCount%array.count)-1;
     if (count == 0) {
     _change = YES;
     }
     }
     [self.scrollView setContentOffset:CGPointMake(kScreenSize.width*count, 0) animated:YES];
     }
     */
}

//创建view
+ (UIView *)creatViewWithFrame:(CGRect)frame backgroundColor:(UIColor *)backgroundColor isLayer:(BOOL)isLayer cornerRadius:(CGFloat)cornerRadius{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = backgroundColor;
    if (isLayer) {
        view.layer.masksToBounds = YES;
        view.layer.cornerRadius = cornerRadius;
    }
    return view;
}


+ (void)creatAlertWithString:(NSString *)string controller:(id)controller autoHiddenTime:(double)autoHiddenTime{
    if (kSystemNo < 8.0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:string delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:string preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
        }]];
        [controller presentViewController:alert animated:YES completion:^{
            if (autoHiddenTime > 0) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(autoHiddenTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [controller dismissViewControllerAnimated:YES completion:nil];
                });
            }
            
        }];
    }
}



//23.创建 BarButtonItem
+ (UIBarButtonItem *)creatUIBarButtomTarget:(id)target sel:(SEL)sel tag:(NSInteger)tag image:(NSString *)name{
    UIImage *image = [[UIImage imageNamed:name] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:target action:sel];
    button.tag = tag;
    
    return button;
}
//24.创建 BarButtonItemSpace
+ (UIBarButtonItem *)creatUIBarButtomOfSpaceSel:(SEL)sel target:(id)target width:(NSInteger)width{
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:target action:sel];
    //宽度
    space.width = width;
    return space;
}



+ (void)Alert:(NSString *)alertStr{
    [LYMessageToast toastWithText:alertStr backgroundColor:[UIColor blackColor] font:[UIFont systemFontOfSize:15] fontColor:[UIColor whiteColor] duration:2.f inView:[[UIApplication sharedApplication].windows lastObject]];
}

@end