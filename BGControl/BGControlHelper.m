//
//  BGControlHelper.m
//  BGBanner
//
//  Created by 周博 on 16/8/29.
//  Copyright © 2016年 BogoZhou. All rights reserved.
//

#import "BGControlHelper.h"
static CGRect oldframe;

@implementation BGControlHelper
+ (CGFloat)getFrameFromAttributedString:(NSAttributedString *)attributedString width:(CGFloat)width{
    CGRect fram = [attributedString boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    return fram.size.height;
}

+ (NSAttributedString *)setAttributedColorWithHtml:(NSString *)html color:(UIColor *)color{
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithData:[html dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,NSForegroundColorAttributeName :[UIColor redColor]} documentAttributes:nil error:nil];
    [attributedString addAttributes:@{NSForegroundColorAttributeName :color} range:NSMakeRange(0,attributedString.length)];
    return attributedString;
}
+ (CGColorRef)getButttonBurderColorWithR:(NSInteger)R G:(NSInteger)G B:(NSInteger)B{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ R/255.0f, G/255.0f, B/255.0f, 1 });
    return colorref;
}
//动态 计算行高
//根据字符串的实际内容的多少 在固定的宽度和字体的大小，动态的计算出实际的高度
+ (CGFloat)textHeightFromTextString:(NSString *)text width:(CGFloat)textWidth fontSize:(CGFloat)size{
    if (kSystemNo >= 7.0) {
        //iOS7之后
        /*
         第一个参数: 预设空间 宽度固定  高度预设 一个最大值
         第二个参数: 行间距 如果超出范围是否截断
         第三个参数: 属性字典 可以设置字体大小
         */
        NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:size]};
        CGRect rect = [text boundingRectWithSize:CGSizeMake(textWidth, MAXFLOAT) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
        //返回计算出的行高
        return rect.size.height;
        
    }else {
        //iOS7之前
        /*
         1.第一个参数  设置的字体固定大小
         2.预设 宽度和高度 宽度是固定的 高度一般写成最大值
         3.换行模式 字符换行
         */
        CGSize textSize = [text sizeWithFont:[UIFont fontWithName:kFontName size:size] constrainedToSize:CGSizeMake(textWidth, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
        return textSize.height;//返回 计算出得行高
    }
}

/**
 *  将两张图片合二为一,一般用于二维码上添加图片
 *
 *  @param image1 要添加在二维码上的图片
 *  @param image2 二维码
 *
 *  @return 合成之后的image
 */
+ (UIImage *)addImage:(UIImage *)image1 toImage:(UIImage *)image2{
    UIGraphicsBeginImageContext(image2.size);
    
    // Draw image1
    [image2 drawInRect:CGRectMake(0, 0, image2.size.width, image2.size.height)];
    
    // Draw image2
    [image1 drawInRect:CGRectMake((image2.size.width-image1.size.width)/2, (image2.size.height-image1.size.height)/2, image1.size.width, image1.size.height)];
    
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resultingImage;
}

+ (CGSize)labelAutoCalculateRectWith:(NSString*)text FontSize:(CGFloat)fontSize MaxSize:(CGSize)maxSize{
    
    //调用的函数
    
    //    CGSize maxSize = CGSizeMake(MAXFLOAT, 40);
    //
    //    CGSize titleSize = [self labelAutoCalculateRectWith:_publicDetail.name FontSize:15.0f MaxSize:maxSize];
    //
    //    　UILabel *label = [UILabel alloc]init];
    //
    //    　label.frame = CGRectMake(0 , 0, titleSize.width, titleSize.height);
    
    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    
    paragraphStyle.lineBreakMode=NSLineBreakByWordWrapping;
    
    NSDictionary* attributes =@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize],NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    //如果系统为iOS7.0；
    
    CGSize labelSize;
    
    if (![text respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]){
        
        labelSize = [text sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:maxSize lineBreakMode:NSLineBreakByCharWrapping];
        
    }
    //如果是IOS6.0
    　else{
        labelSize = [text boundingRectWithSize: maxSize
                     
                                       options: NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine
                     
                                    attributes:attributes
                     
                                       context:nil].size;
    }
    labelSize.height=ceil(labelSize.height);
    
    labelSize.width=ceil(labelSize.width);
    return labelSize;
}

+(UIImage *)scale:(UIImage *)image toSize:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha{
    //删除字符串中的空格
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6)
    {
        return [UIColor clearColor];
    }
    // strip 0X if it appears
    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([cString hasPrefix:@"0X"])
    {
        cString = [cString substringFromIndex:2];
    }
    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([cString hasPrefix:@"#"])
    {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6)
    {
        return [UIColor clearColor];
    }
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha];
}

//UIColor 转UIImage
+ (UIImage*) imageWithColor: (UIColor*) color{
    CGRect rect=CGRectMake(0,0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

+(void)showImage:(UIImageView*)avatarImageView{
    
    UIImage*image = avatarImageView.image;
    
    UIWindow * window=[UIApplication sharedApplication].keyWindow;
    
    UIView * backgroundView=[[UIView alloc]initWithFrame:CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    
    oldframe=[avatarImageView convertRect:avatarImageView.bounds toView:window];
    
    backgroundView.backgroundColor=[UIColor blackColor];
    
    backgroundView.alpha=0;
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:oldframe];
    
    imageView.image=image;
    
    imageView.tag=1;
    
    [backgroundView addSubview:imageView];
    
    [window addSubview:backgroundView];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
    
    [backgroundView addGestureRecognizer: tap];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        imageView.frame = CGRectMake(0,([UIScreen mainScreen].bounds.size.height-image.size.height * [UIScreen mainScreen].bounds.size.width/image.size.width)/2, [UIScreen mainScreen].bounds.size.width, image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width);
        backgroundView.alpha=1;
    }
                     completion:^(BOOL finished) {
                     }];
}

+(void)hideImage:(UITapGestureRecognizer*)tap{
    
    UIView *backgroundView=tap.view;
    
    UIImageView *imageView=(UIImageView*)[tap.view viewWithTag:1];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        imageView.frame=oldframe;
        
        backgroundView.alpha=0;
    }
                     completion:^(BOOL finished) {
                         [backgroundView
                          removeFromSuperview];
                     }];
}

+ (void)setViewBorder:(UIView *)view{
    view.layer.borderWidth = 1.f;
    //    view.backgroundColor = kfafafa;
    view.layer.borderColor = [kColorFrom0x(kE6E6E6) CGColor];
    view.layer.cornerRadius = kButtonCornerRadius;
    
    //    CALayer *layer = [CALayer layer];
    //    layer.frame = CGRectMake(0, 0, view.frame.size.width, 0.25f);
    //    layer.backgroundColor = [kTextColor CGColor];
    //    [view.layer addSublayer:layer];
    //
    //    CALayer *layer1 = [CALayer layer];
    //    layer1.frame = CGRectMake(0, view.frame.size.height-0.25f, view.frame.size.width, 0.25f);
    //    layer1.backgroundColor = [kTextColor CGColor];
    //    [view.layer addSublayer:layer1];
}

+ (void)setWhiteViewBorder:(UIView *)view{
    view.layer.borderWidth = 0.5f;
    view.layer.borderColor = [kColorFrom0x(kFAFAFA) CGColor];
}

+ (void)setUPDOWNViewBorder:(UIView *)view{
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, view.frame.size.width, 0.5f);
    layer.backgroundColor = [kColorFrom0x(kE6E6E6) CGColor];
    [view.layer addSublayer:layer];
    
    CALayer *layer1 = [CALayer layer];
    layer1.frame = CGRectMake(0, view.frame.size.height-0.25f, view.frame.size.width, 0.5f);
    layer1.backgroundColor = [kColorFrom0x(kE6E6E6) CGColor];
    [view.layer addSublayer:layer1];
}

+ (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

+(UIImage*)originImage:(UIImage*)image scaleToSize:(CGSize)size

{
    
    UIGraphicsBeginImageContext(size);//size为CGSize类型，即你所需要的图片尺寸
    
    [image drawInRect:CGRectMake(0,0, size.width, size.height)];
    
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;
    
}

@end
