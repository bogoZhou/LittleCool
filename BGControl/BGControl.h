//
//  BGControl.h
//  MyControl
//
//  Created by chenghong_mac on 15/7/30.
//  Copyright (c) 2015年 Bogo. All rights reserved.
//


#import "BGSDK.h"


@interface BGControl : NSObject<UIAlertViewDelegate>
/**
 *  1.创建 Label
 *
 *  @param frame           label 的frame
 *  @param text            显示的内容
 *  @param font            字体大小
 *  @param numberOfLine    显示的行数  0 -> 全部显示
 *  @param isLayer         是否允许切割
 *  @param cornerRadius    边角弧度
 *  @param backgroundColor 背景色
 *
 *  @return  设置好的 label
 */
+ (UILabel *)creatLabelWithFrame:(CGRect)frame text:(NSString *)text font:(UIFont *)font numberOfLine:(NSInteger)numberOfLine isLayer:(BOOL)isLayer cornerRadius:(CGFloat)cornerRadius backgroundColor:(UIColor *)backgroundColor;

/**
 *  2.创建 Button
 *
 *  @param frame             位置
 *  @param target            按钮目标
 *  @param sel               添加选择器
 *  @param tag               设置 tag 值
 *  @param image             设置 button 的图片 若没有,写 nil
 *  @param isBackgroundImage 判断该图片是否是 button 的背景图
 *  @param title             button 的 title 若没有,写 nil
 *  @param isLayer           是否允许切割
 *  @param cornerRadius      设置边角弧度
 *
 *  @return 设置好的 button
 */
+ (UIButton *)creatButtonWithFrame:(CGRect)frame target:(id)target sel:(SEL)sel tag:(NSInteger)tag image:(NSString *)image isBackgroundImage:(BOOL)isBackgroundImage title:(NSString *)title isLayer:(BOOL)isLayer cornerRadius:(CGFloat)cornerRadius;

/**
 *  3.创建 ImageView
 *
 *  @param frame        位置
 *  @param image        设置图片
 *  @param isWebImage   判断图片是否是来自网络的图片
 *  @param holdOnImage  设置 holder 图片
 *  @param isLayer      是否允许切割
 *  @param cornerRadius 设置边角弧度
 *
 *  @return 设置好的 imageView
 */
+ (UIImageView *)creatImageViewWithFrame:(CGRect)frame image:(NSString *)image isWebImage:(BOOL)isWebImage holdOnImage:(NSString *)holdOnImage isLayer:(BOOL)isLayer cornerRadius:(CGFloat)cornerRadius;

/**
 *  4.创建 TextField
 *
 *  @param frame       位置
 *  @param placeHolder
 *  @param borderStyle 边框的类型  
 UITextBorderStyleNone,
 UITextBorderStyleLine,
 UITextBorderStyleBezel,
 UITextBorderStyleRoundedRect
 
 *  @param delegate    代理
 *  @param tag         设置 tag 值
 *
 *  @return 设置好的 TextField
 */
+ (UITextField *)creatTextFieldWithFrame:(CGRect)frame placeHolder:(NSString *)placeHolder borderStyle:(UITextBorderStyle )borderStyle delegate:(id<UITextFieldDelegate>)delegate tag:(NSInteger)tag;

//5.创建 TextView
/*
 1、设置文本属性：text；
 2、设置文字对齐方式属性：textAlignment；
 3、设置文字颜色属性：textColor；
 4、设置文字字体属性：font；
 5、设置编辑使能属性：editable；
 6、设置背景颜色属性：backgroundColor；
 7、圆角边框：layer.cornerRadius、layer.borderWidth。
 */
+ (UITextView *)creatTextViewWithFrame:(CGRect)frame text:(NSString *)text textAlignment:(NSTextAlignment)textAlignment textColor:(UIColor *)textColor font:(UIFont *)font isEditable:(BOOL)isEditable backgroundColor:(UIColor *)backgroundColor isLayer:(BOOL)isLayer cornerRadius:(CGFloat)cornerRadius delegate:(id<UITextViewDelegate>)delegate;

/**
 *  6.创建滚动视图，广告
 *
 *  @param frame            滚动视图的 frame
 *  @param dataArr          将要展示的图片数组
 *  @param delegate         滚动视图的代理
 *  @param time             滚动的时间 间隔
 *  @param target           滚动视图的目标  self
 *  @param btnSel           点击事件对应的 选择器
 *  @param timerSel         计时器对应的选择器
 *  @param userInfo         一般为 nil
 *  @param repeats          是否重复 好像作用不大
 *  @param isLocalImage     图片是否是本地图片
 *  @param placeHolderImage 若不是本地图片 加入 placeHolder 图片
 *
 *  @return 设置好的 scrollView
 */
+ (UIScrollView *)creatScrollViewWithFrame:(CGRect)frame dataArr:(NSArray*)dataArr delegate:(id<UIScrollViewDelegate>)delegate time:(NSTimeInterval)time target:(id)target btnSel:(SEL)btnSel timerSel:(SEL)timerSel userInfo:(id)userInfo repeats:(BOOL)repeats isLocalImage:(BOOL)isLocalImage placeHolderImage:(NSString *)placeHolderImage;

/**
 *  7.创建 view
 *
 *  @param frame           要创建view的frame
 *  @param backgroundColor 要创建view的背景色
 *  @param isLayer         要创建的view是否需要裁减
 *  @param cornerRadius    弧度
 *
 *  @return 创建完成的view
 */
+ (UIView *)creatViewWithFrame:(CGRect)frame backgroundColor:(UIColor *)backgroundColor isLayer:(BOOL)isLayer cornerRadius:(CGFloat)cornerRadius;



/**
 *  9.警告框   ---> iOS 9.0 之后UIAlertView 取消使用  现使用 UIAlertController
 *
 *  @param string     要显示的名字
 *  @param controller 当前的controller (self)
 *
 *  @return 警告框
 */
+ (void)creatAlertWithString:(NSString *)string controller:(id)controller autoHiddenTime:(double)autoHiddenTime;



/**
 *  23.创建 BarButtonItem
 *
 *  @param target 目标 (self)
 *  @param sel    选择器
 *  @param tag    tag值
 *  @param name   图片的名字
 *
 *  @return nav -> buttonItem
 */
+ (UIBarButtonItem *)creatUIBarButtomTarget:(id)target sel:(SEL)sel tag:(NSInteger)tag image:(NSString *)name;

/**
 *  24.创建 BarButtonItemSpace
 *
 *  @param sel    选择器
 *  @param target 目标 (self)
 *  @param width  buttonItem 中间的 空间
 *
 *  @return nav -> buttonItem 中间的空间
 */
+ (UIBarButtonItem *)creatUIBarButtomOfSpaceSel:(SEL)sel target:(id)target width:(NSInteger)width;

/**
 *  弹出警告框
 */
+ (void)Alert:(NSString *)alertStr;

@end
