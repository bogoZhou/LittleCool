//
//  BGDateHelper.m
//  BGBanner
//
//  Created by 周博 on 16/8/29.
//  Copyright © 2016年 BogoZhou. All rights reserved.
//

#import "BGDateHelper.h"

@implementation BGDateHelper
+ (NSString *)getTimeStringFromNumberTimer:(NSString *)timerStr isMinuteLater:(BOOL)isMinute{
    NSDate *longDate;
    NSDate *strDate;
    //转化为 时间格式化字符串
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    //    df.dateFormat = @"HH:mm";
    //    df.dateFormat = @"MM-dd";
    
    
    if (timerStr.longLongValue >10000) {
        
    }else{
        strDate = [df dateFromString:timerStr];
        timerStr = [NSString stringWithFormat:@"%ld",(long)[strDate timeIntervalSince1970]*1000];
        //        NSLog(@"%@",timerStr);
    }
    
    //转化为Double
    if (isMinute) {
        df.dateFormat = @"yyyy-MM-dd";
    }
    double t = [timerStr doubleValue]/1000;
    longDate = [NSDate dateWithTimeIntervalSince1970:t];
    NSString *theDay = [df stringFromDate:longDate];//日期的年月日
    NSString *currentDay = [df stringFromDate:[NSDate date]];//当前年月日
    NSInteger timeInterval = -[longDate timeIntervalSinceNow];
    if (isMinute) {
//        if (timeInterval < 60) {
//            return @"1分钟内";
//        } else if (timeInterval < 3600) {//1小时内
//            return [NSString stringWithFormat:@"%ld分钟前", timeInterval / 60];
//        } else if (timeInterval < 21600) {//6小时内
//            return [NSString stringWithFormat:@"%ld小时前", timeInterval / 3600];
//        } else if ([theDay isEqualToString:currentDay]) {//当天
//            [df setDateFormat:@"HH:mm:ss"];
//            return [NSString stringWithFormat:@"%@", [df stringFromDate:longDate]];
//        }else if (timeInterval < 21600 * 4 *2){
//            return [NSString stringWithFormat:@"昨天", timeInterval / 86400];
//        }
//        else {//以前
            df.dateFormat = @"yyyy-MM-dd HH:mm:ss";
            NSString *theDay = [df stringFromDate:longDate];//日期的年月日
            NSString *currentDay = [df stringFromDate:[NSDate date]];//当前年月日
            
            NSInteger timeInt = ([self getTimeStempByString:currentDay havehh:YES].longLongValue - [self getTimeStempByString:theDay havehh:YES].longLongValue)/86400/1000;
            //            [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            //            return [df stringFromDate:longDate];]
            //            NSLog(@"%ld",timeInt);
            if (timeInt == 0) {
                [df setDateFormat:@"HH:mm"];
                return [NSString stringWithFormat:@"%@",[df stringFromDate:longDate]];
            }else if (timeInt == 1){
                [df setDateFormat:@"HH:mm"];
                return [NSString stringWithFormat:@"昨天 %@",[df stringFromDate:longDate]];
            }else{
                [df setDateFormat:@"yyyy年MM月dd日 HH:mm"];
                return [NSString stringWithFormat:@"%@",[df stringFromDate:longDate]];
            }
//        }
    }else{
        df.dateFormat = @"MM-dd";
        return [df stringFromDate:longDate];
    }
}


//返回今天星期几
+ (NSInteger)weekDay{
    NSDateComponents *componets = [[NSCalendar autoupdatingCurrentCalendar] components:NSCalendarUnitWeekday fromDate:[NSDate date]];
    NSInteger weekday = [componets weekday];
    //    NSLog(@"%ld",weekday);
    return weekday;
}
//返回今天几号
+ (NSArray *)seeDay{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *date = [NSDate date];
    //NSDateComponents *compt = [calendar components:NSDayCalendarUnit fromDate:date];
    NSDateComponents *compt = [calendar components:(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond) fromDate:date];
    
    NSString *locationString1 = [NSString stringWithFormat:@"%ld-%.2ld-%.2ld",[compt year],[compt month],[compt day]];
    
    NSString *locationString2 = [NSString stringWithFormat:@"%ld",[compt year]];
    
    NSString *locationString3 = [NSString stringWithFormat:@"%.2ld",[compt month]];
    
    NSString *locationString4 = [NSString stringWithFormat:@"%.2ld",[compt day]];
    
    NSString *locationString5 = [NSString stringWithFormat:@"%ld-%.2ld-%.2ld %.2ld:%.2ld",[compt year],[compt month],[compt day],[compt hour],[compt minute]];
    
    NSString *locationString6 = [NSString stringWithFormat:@"%ld-%.2ld-%.2ld %.2ld:%.2ld:%.2ld",[compt year],[compt month],[compt day],[compt hour],[compt minute],[compt second]];
    
    NSString *locationString7 = [NSString stringWithFormat:@"%.2ld:%.2ld",[compt hour],[compt minute]];
    
    NSArray *dayArray = @[locationString1,locationString2,locationString3,locationString4,locationString5,locationString6,locationString7];
    //    NSLog(@"%@",dayArray);
    return dayArray;
}
//返回今天左右几号
+ (NSArray *)seeDayAroundToday:(NSInteger)dayNum{
    NSInteger dayNUM = dayNum * 86400;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:dayNUM];
    //NSDateComponents *compt = [calendar components:NSDayCalendarUnit fromDate:date];
    NSDateComponents *compt = [calendar components:(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond) fromDate:date];
    
    NSString *locationString1 = [NSString stringWithFormat:@"%ld-%.2ld-%.2ld",[compt year],[compt month],[compt day]];
    
    NSString *locationString2 = [NSString stringWithFormat:@"%ld",[compt year]];
    
    NSString *locationString3 = [NSString stringWithFormat:@"%.2ld",[compt month]];
    
    NSString *locationString4 = [NSString stringWithFormat:@"%.2ld",[compt day]];
    
    NSString *locationString5 = [NSString stringWithFormat:@"%ld-%.2ld-%.2ld %.2ld:%.2ld",[compt year],[compt month],[compt day],[compt hour],[compt minute]];
    NSArray *dayArray = @[locationString1,locationString2,locationString3,locationString4,locationString5];
    //    NSLog(@"%@",dayArray);
    return dayArray;
}


/**
 *  将时间字符串转变为时间戳
 *
 *  @param timeStr 传入时间字符串
 *
 *  @return 时间戳
 */
+ (NSString *)getTimeStempByString:(NSString *)timeStr havehh:(BOOL)havehh{
    NSString* dateStr = timeStr;
    
    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
    if (havehh) {
        [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }else{
        [formater setDateFormat:@"yyyy-MM-dd"];
    }
    
    NSDate* date = [formater dateFromString:dateStr];
    NSString *timeSp = [NSString stringWithFormat:@"%ld000",(long)[date timeIntervalSince1970]];
    return timeSp;
}

+ (NSArray *)getTimeArrayByTimeString:(NSString *)timeString{
    NSDate *longDate;
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    double t = [timeString doubleValue]/1000;
    longDate = [NSDate dateWithTimeIntervalSince1970:t];
    NSString *locationString1 = [dateformatter stringFromDate:longDate];
    
    [dateformatter setDateFormat:@"YYYY"];
    t = [timeString doubleValue]/1000;
    longDate = [NSDate dateWithTimeIntervalSince1970:t];
    NSString *locationString2 = [dateformatter stringFromDate:longDate];
    
    [dateformatter setDateFormat:@"MM"];
    t = [timeString doubleValue]/1000;
    longDate = [NSDate dateWithTimeIntervalSince1970:t];
    NSString *locationString3 = [dateformatter stringFromDate:longDate];
    
    [dateformatter setDateFormat:@"dd"];
    t = [timeString doubleValue]/1000;
    longDate = [NSDate dateWithTimeIntervalSince1970:t];
    NSString *locationString4 = [dateformatter stringFromDate:longDate];
    
    [dateformatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    t = [timeString doubleValue]/1000;
    longDate = [NSDate dateWithTimeIntervalSince1970:t];
    NSString *locationString5 = [dateformatter stringFromDate:longDate];
    
    [dateformatter setDateFormat:@"HH:mm"];
    t = [timeString doubleValue]/1000;
    longDate = [NSDate dateWithTimeIntervalSince1970:t];
    NSString *locationString6 = [dateformatter stringFromDate:longDate];
    
    NSArray *dayArray = @[locationString1,locationString2,locationString3,locationString4,locationString5,locationString6];
    //    NSLog(@"%@",dayArray);
    return dayArray;
}

//返回某天星期几
+ (NSInteger)weekDay:(NSString *)dayNum{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[dayNum longLongValue]/1000];
    
    NSDateComponents *componets = [calendar components:NSCalendarUnitWeekday fromDate:date];
    NSInteger weekday = [componets weekday];
    //    NSLog(@"%ld",weekday);
    return weekday;
}

//返回今天是这个月的第几周
+ (NSInteger)seeWeekNumInMonth:(NSString *)dayNum{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[dayNum longLongValue]/1000];
    NSDateComponents *componets = [calendar components:NSCalendarUnitWeekOfMonth fromDate:date];
    NSInteger weekNumInMonth = [componets weekOfMonth];
    return weekNumInMonth;
}

@end
