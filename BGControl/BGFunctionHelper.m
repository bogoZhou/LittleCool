//
//  BGFunctionHelper.m
//  BGBanner
//
//  Created by 周博 on 16/8/29.
//  Copyright © 2016年 BogoZhou. All rights reserved.
//

#import "BGFunctionHelper.h"

@implementation BGFunctionHelper

+ (NSDictionary *)getJsonData:(id)data{
    NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    return jsonData;
}

+ (NSString *)MD5SecretCode:(NSString *)password{
    const char *cStr = [password UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}



+ (void)creatExitAlertWithString:(NSString *)string controller:(id)controller autoHiddenTime:(double)autoHiddenTime{
    if (kSystemNo < 8.0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:string delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        alert.delegate = self;
        [alert show];
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:string preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"mobile"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"password"];
            [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"FIRST"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"lead" object:nil];
        }]];
        
        
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"mobile"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"password"];
        [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"FIRST"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"lead" object:nil];
    }
}


+ (NSString *)getStringWithHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    
    NSString * regEx = @"<([^>]*)>&";
    html = [html stringByReplacingOccurrencesOfString:regEx withString:@""];
    return html;
}

+ (NSAttributedString *)showViewWithHtml:(NSString *)html{
    NSAttributedString * attributedString = [[NSAttributedString alloc] initWithData:[html dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    return attributedString;
}

+ (NSURL *)getURLWithFormat:(NSString *)string1 string2:(NSString *)string2{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",string1,string2]];
    return url;
}

+ (NSString *)deviceIPAdress {
    NSString *address = @"an error occurred when obtaining ip address";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    success = getifaddrs(&interfaces);
    
    if (success == 0) { // 0 表示获取成功
        
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    freeifaddrs(interfaces);
    //DDLogVerbose(@"手机的IP是：%@", address);
    return address;
}

//获取本地文件信息  json
+ (NSMutableArray *)getCityDataFileName:(NSString *)fileName type:(NSString *)type
{
    NSArray *jsonArray = [[NSArray alloc]init];
    NSData *fileData = [[NSData alloc]init];
    NSUserDefaults *UD = [NSUserDefaults standardUserDefaults];
    if ([UD objectForKey:@"text"] == nil) {
        NSString *path;
        path = [[NSBundle mainBundle] pathForResource:fileName ofType:type];
        
        fileData = [NSData dataWithContentsOfFile:path];
        
        [UD setObject:fileData forKey:@"text"];
        [UD synchronize];
    }
    else {
        fileData = [UD objectForKey:@"text"];
    }
    NSMutableArray *array = [[NSMutableArray alloc]initWithCapacity:0];
    jsonArray = [NSJSONSerialization JSONObjectWithData:fileData options:NSJSONReadingMutableLeaves error:nil];
    for (NSDictionary *dict in jsonArray) {
        [array addObject:dict];
    }
    
    return array;
}

+ (NSMutableArray *)chineseSequence:(NSMutableArray *)stringsToSort{
    NSMutableArray *chineseStringsArray=[NSMutableArray array];
    for(int i=0;i<[stringsToSort count];i++){
        ChineseString *chineseString=[[ChineseString alloc]init];
        
        chineseString.string=[NSString stringWithString:[stringsToSort objectAtIndex:i]];
        
        if(chineseString.string==nil){
            chineseString.string=@"";
        }
        
        if(![chineseString.string isEqualToString:@""]){
            NSString *pinYinResult=[NSString string];
            for(int j=0;j<chineseString.string.length;j++){
                NSString *singlePinyinLetter=[[NSString stringWithFormat:@"%c",pinyinFirstLetter([chineseString.string characterAtIndex:j])]uppercaseString];
                
                pinYinResult=[pinYinResult stringByAppendingString:singlePinyinLetter];
            }
            chineseString.pinYin=pinYinResult;
        }else{
            chineseString.pinYin=@"";
        }
        [chineseStringsArray addObject:chineseString];
    }
    
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"pinYin" ascending:YES]];
    [chineseStringsArray sortUsingDescriptors:sortDescriptors];
    
    NSMutableArray *result=[NSMutableArray array];
    for(int i=0;i<[chineseStringsArray count];i++){
        [result addObject:((ChineseString*)[chineseStringsArray objectAtIndex:i]).string];
    }
    
    return result;
}

+ (NSString *)getCurrentIOS {
    return [[UIDevice currentDevice] systemVersion];
}

//正则判断手机号
+ (BOOL)checkTel:(NSString *)str
{
    if ([str length] == 0) {
        //        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的手机格式" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        //        [alert show];
        return NO;
    }
    //1[0-9]{10}
    //^((13[0-9])|(15[^4,\\D])|(18[0,5-9]))\\d{8}$
    //    NSString *regex = @"[0-9]{11}";
    NSString *regex = @"^1[3-8]\\d{9}$";
    //    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:str];
    if (!isMatch) {
        //        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的手机号码" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        //        [alert show];
        return NO;
    }
    return YES;
}

//字典转Data
+(NSData*)returnDataWithDictionary:(NSDictionary*)dict{
    NSMutableData* data = [[NSMutableData alloc]init];
    NSKeyedArchiver* archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    [archiver encodeObject:dict forKey:@"talkData"];
    [archiver finishEncoding];
    return data;
}
+ (NSString*)deviceVersion
{
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6S";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6S Plus";
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    
    //CLog(@"NOTE: Unknown device type: %@", deviceString);
    
    return deviceString;
}

+ (NSString *)readKeyChain:(NSString *)key{
    KIKeyChain *keyChain = [KIKeyChain keyChainWithIdentifier:@"default_user"];
    
    return [keyChain valueForKey:key];
}

+ (void)writeKeyChain:(NSString *)uuid key:(NSString *)key{
    KIKeyChain *keyChain = [KIKeyChain keyChainWithIdentifier:@"default_user"];
    [keyChain setValue:uuid forKey:key];
    //    [key setValue:@"password1" forKey:@"password"];
    [keyChain write];
}

//plist 存储地址
+ (NSString*)filePath:(NSString*)fileName{
    NSArray* myPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* myDocPath = [myPaths objectAtIndex:0];
    NSString* filePath = [myDocPath stringByAppendingPathComponent:fileName];
    return filePath;
}

//存储方法
+ (NSMutableDictionary *)saveUserInfoInDictionary:(NSMutableDictionary *)dic key:(NSString *)key value:(NSString *)value{
    if ([self isNULLOfString:value]) {
        [dic setObject:@"" forKey:key];
    }else{
        [dic setObject:value forKey:key];
    }
    return dic;
}

//判断是否为空
+ (BOOL)isNULLOfString:(NSString *)string{
    //    NSString * string = [NSString stringWithFormat:@"%@",string1];
    if (string == NULL) {
        return YES;
    }
    
    if (string == nil) {
        return YES;
    }
    
    if ([@"" isEqualToString:string]) {
        return YES;
    }
    
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    
    if ([string isEqualToString:@"<null>"]) {
        return YES;
    }
    if ([string isEqualToString:@"(null)"]) {
        return YES;
    }
    
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

+ (BOOL)isAllowedNotification{
    //iOS8 check if user allow notification
    if([self getCurrentIOS].floatValue > 8.f) {// system is iOS8
        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if(UIUserNotificationTypeNone != setting.types) {
            return YES;
        }
    }
    else{//iOS7
        UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        if(UIRemoteNotificationTypeNone != type)
            return YES;
    }
    return NO;
}

+ (NSArray *)cutString:(NSString *)fatherStr ByCutString:(NSString *)cutString{
    NSArray *array = [fatherStr componentsSeparatedByString:cutString];
    return array;
}

+ (NSArray *)filterArray:(NSArray *)array predicate:(NSString *)predicate{
    NSPredicate * fiecate=[NSPredicate predicateWithFormat:@"SELF CONTAINS %@",predicate];
    NSArray * arr3=[array filteredArrayUsingPredicate:fiecate];
    
    //    NSLog(@"这是我过滤的数组对吗？%@",arr3);
    return arr3;
}

+ (BOOL)stringContainsEmoji:(NSString *)string{
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            returnValue = YES;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3) {
                                        returnValue = YES;
                                    }
                                } else {
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        returnValue = YES;
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        returnValue = YES;
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        returnValue = YES;
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        returnValue = YES;
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}

+ (BOOL)majorString:(NSString *)majorString isContainMinorString:(NSString *)minorString{
    BOOL isContent = NO;
    if ([majorString rangeOfString:minorString].location  != NSNotFound) {
        return !isContent;
    }
    return isContent;
}


//正则判断数字
+ (BOOL)checkNum:(NSString *)str
{
    if ([str length] == 0) {
        return NO;
    }
    NSString *regex = @"^[0-9]*$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:str];
    if (!isMatch) {
        return NO;
    }
    return YES;
}

+ (BOOL)checkE_Mail:(NSString *)str{
    if ([str length] == 0) {
        return NO;
    }
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL isMatch = [pred evaluateWithObject:str];
    if (!isMatch) {
        return NO;
    }
    return YES;
}

+ (NSString *)creatHeadURLBy:(NSString *)headurl{
    NSArray *nameArray = [headurl componentsSeparatedByString:@"://"];
    NSString *head_Url = [NSString stringWithFormat:@"%@%@",@"https://",nameArray.lastObject];
    return head_Url;
}

+ (UIImage *)bundleImageName:(NSString *)name type:(NSString *)type bundle:(NSString *)bundle{
    NSString *bundlePath = [[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.bundle",bundle]];
    NSBundle *bundles = [NSBundle bundleWithPath:bundlePath];
    NSString *imagePath = [bundles pathForResource:name ofType:type];
    
    return [UIImage imageWithContentsOfFile:imagePath];
}

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    
    if ([cString length] < 6)
        return kBlackColor;
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return kBlackColor;
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

+(UIImage *) loadImage:(NSString *)fileName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath {
    UIImage * result = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.%@", directoryPath, fileName, extension]];
    
    return result;
}
@end
