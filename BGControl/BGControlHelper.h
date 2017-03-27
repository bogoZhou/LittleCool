//
//  BGControlHelper.h
//  BGBanner
//
//  Created by 周博 on 16/8/29.
//  Copyright © 2016年 BogoZhou. All rights reserved.
//

#import "BGSDK.h"

@interface BGControlHelper : NSObject
/**
 *  13.根据富文本的宽度计算高度
 *
 *  @param attributedString 传入富文本
 *  @param width            将要展示的宽度
 *
 *  @return 合适的高度
 */
+ (CGFloat)getFrameFromAttributedString:(NSAttributedString *)attributedString width:(CGFloat)width;

/**
 *  14.为富文本设置统一的颜色
 *
 *  @param html  将html内容以字符串的形式传入该方法
 *  @param color 内容字体将要改变的文字
 *
 *  @return 富文本形式
 */
+ (NSAttributedString *)setAttributedColorWithHtml:(NSString *)html color:(UIColor *)color;

/**
 *  15.设置按钮边框颜色
 *
 *  @param R
 *  @param G
 *  @param B
 *
 *  @return 边框颜色
 */
+ (CGColorRef)getButttonBurderColorWithR:(NSInteger)R G:(NSInteger)G B:(NSInteger)B;

/**
 *  19.根据字符串内容的多少  在固定宽度 下计算出实际的行高
 *
 *  @param text      内容
 *  @param textWidth 宽度
 *  @param size      字体大小
 *
 *  @return 高度
 */
+ (CGFloat)textHeightFromTextString:(NSString *)text width:(CGFloat)textWidth fontSize:(CGFloat)size;

/**
 *  37.将两张图片合二为一,一般用于二维码上添加图片
 *
 *  @param image1 要添加在二维码上的图片
 *  @param image2 二维码
 *
 *  @return 合成之后的image
 */
+ (UIImage *)addImage:(UIImage *)image1 toImage:(UIImage *)image2;

/**
 *  38.根据内容返回label的宽度
 *
 *  @param text     内容
 *  @param fontSize 字体大小
 *  @param maxSize  最大宽度
 *
 *  @return label的宽度
 */
+ (CGSize)labelAutoCalculateRectWith:(NSString*)text FontSize:(CGFloat)fontSize MaxSize:(CGSize)maxSize;

/**
 *  40.图片模糊处理
 *
 *  @param image 图片
 *  @param size  大小
 *
 *  @return 模糊的图片
 */
+(UIImage *)scale:(UIImage *)image toSize:(CGSize)size;

/**
 *  43.根据16进制颜色转换为  普通RGB颜色
 *
 *  @param color 16进制颜色
 *  @param alpha 透明度
 *
 *  @return 普通RGB颜色
 */
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

/**
 *  44.颜色转image
 *
 *  @param color 颜色
 *
 *  @return image
 */
+ (UIImage*) imageWithColor: (UIColor*) color;

/**
 *  浏览大图
 *
 *  @param avatarImageView 要显示的图片
 */
+(void)showImage:(UIImageView*)avatarImageView;

/**
 *  设置view的borderWidth and borderColor
 */
+ (void)setViewBorder:(UIView *)view;


/**
 *  白色view加边
 */
+ (void)setWhiteViewBorder:(UIView *)view;

+ (void)setUPDOWNViewBorder:(UIView *)view;

+ (UIImage *)fixOrientation:(UIImage *)aImage;

+(UIImage*)originImage:(UIImage*)image scaleToSize:(CGSize)size;

@end
