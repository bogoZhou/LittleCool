//
//  BGFunctionHelper.h
//  BGBanner
//
//  Created by 周博 on 16/8/29.
//  Copyright © 2016年 BogoZhou. All rights reserved.
//

#import "BGSDK.h"

@interface BGFunctionHelper : NSObject
/**
 *  8.将二进制数据转化为标准的字典类型
 *
 *  @param data data形式的数据
 *
 *  @return 将data形式的数据转换成字典类型
 */
+ (NSDictionary *)getJsonData:(id)data;

/**
 *  10.MD5加密
 *
 *  @param password 密钥
 *
 *  @return 加密完成的字符串
 */
+ (NSString *)MD5SecretCode:(NSString *)password;

/**
 *  11.过滤调html中的‘<...>’等标签 但是无法过滤像"&..."这样的标签
 *
 *  @param html 将要过滤的html以字符串的形式传入该方法
 *
 *  @return 过滤空格之后的html形式的字符串
 */
+ (NSString *)getStringWithHTML:(NSString *)html;

/**
 *  12.展示富文本
 *
 *  @param html 将html内容以字符串的形式传入该方法
 *
 *  @return 以富文本形式展示出来
 */
+ (NSAttributedString *)showViewWithHtml:(NSString *)html;




/**
 *  16.将格式化字符串转化为URL
 *
 *  @param string1 拼接字符串1
 *  @param string2 拼接字符串2
 *
 *  @return 拼接完的字符串并转为URL类型
 */
+ (NSURL *)getURLWithFormat:(NSString *)string1 string2:(NSString *)string2;

/**
 *  17.获取设备IP地址
 *
 *  @return 获取设备IP地址
 */
+ (NSString *)deviceIPAdress;

/**
 *  20.获取本地文件信息   例如 json
 *
 *  @param fileName 本地文件的文件名
 *  @param type     文件后缀名 -> 例如:json
 *
 *  @return 解析完成后的数组
 */
+ (NSMutableArray *)getCityDataFileName:(NSString *)fileName type:(NSString *)type;

/**
 *  21.汉语根据拼音排序
 *
 *  @param stringsToSort 存有 汉字 的数组
 *
 *  @return 排好顺序的数组
 */
+ (NSMutableArray *)chineseSequence:(NSMutableArray *)stringsToSort;


/**
 *  22.获取iOS 版本号
 *
 *  @return iOS 系统版本号
 */
+ (NSString *)getCurrentIOS;

/**
 *  25.正则判断手机号
 *
 *  @param str 要判断的手机号
 *
 *  @return 满足条件 返回 YES
 */
+ (BOOL)checkTel:(NSString *)str;

/**
 *  29.字典转Data
 *
 *  @param dict 传入字典
 *
 *  @return 将字典形式 转变为 data形式
 */
+(NSData*)returnDataWithDictionary:(NSDictionary*)dict;

/**
 *  30.获取设备型号
 *
 *  @return 获取设备型号 --> 如:iPhone6
 */
+ (NSString*)deviceVersion;

/**
 *  31.读取钥匙串中存取的值
 *
 *  @param key 取出数据的 key
 *
 *  @return 从钥匙串取出的数据
 */
+ (NSString *)readKeyChain:(NSString *)key;

/**
 *  32.将信息写入钥匙串
 *
 *  @param uuid value
 *  @param key  key
 */
+ (void)writeKeyChain:(NSString *)uuid key:(NSString *)key;

/**
 *  33.plist 存储地址
 *
 *  @param fileName 要存入文件的名字
 *
 *  @return 拼接成的存储路径
 */
+ (NSString*)filePath:(NSString*)fileName;

/**
 *  34.存储方法
 *
 *  @param dic   将要放入数据的字典
 *  @param key   key
 *  @param value value
 *
 *  @return 判断过 空 的字典
 */
+ (NSMutableDictionary *)saveUserInfoInDictionary:(NSMutableDictionary *)dic key:(NSString *)key value:(NSString *)value;

/**
 *  35.判断是否为空
 *
 *  @param string 要判断是否为空的字符串
 *
 *  @return 空 -> YES
 */
+ (BOOL)isNULLOfString:(NSString *)string;

/**
 *  判断推送是否打开
 */
+ (BOOL)isAllowedNotification;

/**
 *  39.根据字符截取字符串
 *
 *  @param fatherStr 被截取的字符串
 *  @param cutString 根据 这个 截取
 *
 *  @return 分割好的数组
 */
+ (NSArray *)cutString:(NSString *)fatherStr ByCutString:(NSString *)cutString;

/**
 *  41.用谓词过滤数组
 *
 *  @param array 需要过滤的数组
 *  @param predicate 需要的词
 *
 *  @return 含有该词的数组里面的元素
 */
+ (NSArray *)filterArray:(NSArray *)array predicate:(NSString *)predicate;

/**
 *  判断是否存在emoji
 *
 *  @param string 文字内容
 *
 *  @return YES ->存在
 */
+ (BOOL)stringContainsEmoji:(NSString *)string;

/**
 *  主字符串 中是否包含 次字符串
 *
 *  @param majorString 主字符串
 *  @param minorString 次字符串
 *
 *  @return bool
 */
+ (BOOL)majorString:(NSString *)majorString isContainMinorString:(NSString *)minorString;

//正则判断数字
+ (BOOL)checkNum:(NSString *)str;

+ (void)creatExitAlertWithString:(NSString *)string controller:(id)controller autoHiddenTime:(double)autoHiddenTime;
/**
 *  正则判断是否是邮箱格式
 */
+ (BOOL)checkE_Mail:(NSString *)str;

+ (NSString *)creatHeadURLBy:(NSString *)headurl;

//在bundle中查找对应的image
+ (UIImage *)bundleImageName:(NSString *)name type:(NSString *)type bundle:(NSString *)bundle;

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;

+(UIImage *) loadImage:(NSString *)fileName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath;

+ (UIImage*) imageWithUIView:(UIView*) view;


/**
 将image存入本地沙盒

 @param image 要保存的image
 @return image在沙盒的路径
 */
+ (NSString *)saveImageToSandBoxByImage:(UIImage *)image;


/**
 从沙盒读取image

 @param imagePath 沙盒中image的路径
 @return 从沙盒中获取的image对象
 */
+(UIImage *)getImageFromSandBoxByImagePath:(NSString *)imagePath;


/**
 压缩图片

 @param image 要压缩的图片
 @param maxLength 最大长度
 @return 压缩完成的图片
 */
+ (UIImage *)compressImage:(UIImage *)image toByte:(NSUInteger)maxLength;

+ (UIImage *)compressImageSize:(UIImage *)image toByte:(NSUInteger)maxLength;
@end
