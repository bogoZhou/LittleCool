//
//  BGDateHelper.h
//  BGBanner
//
//  Created by 周博 on 16/8/29.
//  Copyright © 2016年 BogoZhou. All rights reserved.
//

#import "BGSDK.h"

@interface BGDateHelper : NSObject
/**
 *  18.把时间戳转化为时间字符串
 *
 *  @param timerStr 时间字符串 或是 时间戳
 *  @param isMinute 是否 显示为 几分钟前
 *
 *  @return 显示时间字符串
 */
+ (NSString *)getTimeStringFromNumberTimer:(NSString *)timerStr isMinuteLater:(BOOL)isMinute;

/**
 *  26.返回今天星期几
 *
 *  @return 显示今天星期几
 */
+ (NSInteger)weekDay;

/**
 *  27.返回今天几号
 *
 *  @return 返回今天几号
 */
+ (NSArray *)seeDay;

/**
 *  28.返回今天左右几号
 *
 *  @param dayNum 周围的几天  昨天 -> -1, 今天 -> 0, 明天 -> 1
 *
 *  @return 返回今天左右几号
 */
+ (NSArray *)seeDayAroundToday:(NSInteger)dayNum;

/**
 *  36.将时间字符串转变为时间戳
 *
 *  @param timeStr 传入时间字符串
 *
 *  @return 时间戳
 */
+ (NSString *)getTimeStempByString:(NSString *)timeStr havehh:(BOOL)havehh;

/**
 *  42.传入时间戳 传出各个形式 日期
 *
 *  @param timeString 时间戳
 *
 *  @return 返回各个形式 的日期
 */
+ (NSArray *)getTimeArrayByTimeString:(NSString *)timeString;

/**
 *  传入时间戳，返回那一天是这个月的第几周
 */
+ (NSInteger)seeWeekNumInMonth:(NSString *)dayNum;

//返回某天星期几
+ (NSInteger)weekDay:(NSString *)dayNum;

@end
