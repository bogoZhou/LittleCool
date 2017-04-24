//
//  BGTextView.h
//  BGTextViewDemo
//
//  Created by 周博 on 16/12/30.
//  Copyright © 2016年 BogoZhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BGTextView : UITextView


/**
 placeholder 需要传的字符串
 */
@property (nonatomic,strong) NSString *placeholderStr;

/**
 placeHolder 的颜色
 */
@property (nonatomic,strong) UIColor *placeholderColor;

/**
 textView 的字体颜色
 */
@property (nonatomic,strong) UIColor *textViewTextColor;

/**
 textView and placeholder 的 字体
 */
@property (nonatomic,strong) UIFont *textFont;

/**
 textView 和 placeholder 的 字体大小
 */
@property (nonatomic,assign) CGFloat textFontSize;

/**
 用于记录textView 的frame
 */
@property (nonatomic,assign) CGRect viewFrame;

/**
 设置属性之后必须调用该方法重新加载
 */
- (void)updateInfo;
@end
