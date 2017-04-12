//
//  AFClient.m
//  noteMan
//
//  Created by 周博 on 16/12/12.
//  Copyright © 2016年 BogoZhou. All rights reserved.
//

#import "AFClient.h"

@interface AFClient ()<NSURLSessionDelegate>
{
    NSString *_url;
    NSDictionary *_dict;
}
@end

@implementation AFClient


+(instancetype)shareInstance{
    static AFClient *defineAFClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defineAFClient = [[AFClient alloc] init];
    });
    return defineAFClient;
}

- (NSData *)resetSizeOfImageData:(UIImage *)source_image maxSize:(NSInteger)maxSize
{
    //先调整分辨率
    CGSize newSize = CGSizeMake(source_image.size.width, source_image.size.height);
    
    CGFloat tempHeight = newSize.height / 1024;
    CGFloat tempWidth = newSize.width / 1024;
    
    if (tempWidth > 1.0 && tempWidth > tempHeight) {
        newSize = CGSizeMake(source_image.size.width / tempWidth, source_image.size.height / tempWidth);
    }
    else if (tempHeight > 1.0 && tempWidth < tempHeight){
        newSize = CGSizeMake(source_image.size.width / tempHeight, source_image.size.height / tempHeight);
    }
    
    UIGraphicsBeginImageContext(newSize);
    [source_image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //调整大小
    NSData *imageData = UIImageJPEGRepresentation(newImage,1.0);
    NSUInteger sizeOrigin = [imageData length];
    NSUInteger sizeOriginKB = sizeOrigin / 1024;
    if (sizeOriginKB > maxSize) {
        NSData *finallImageData = UIImageJPEGRepresentation(newImage,0.50);
        return finallImageData;
    }
    
    return imageData;
}

- (AFHTTPSessionManager *)creatManager{
    AFHTTPSessionManager* mgr = [AFHTTPSessionManager manager];
    
//        mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    //allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO//如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    //validatesDomainName 是否需要验证域名，默认为YES；
    securityPolicy.validatesDomainName = NO;
    
    mgr.securityPolicy  = securityPolicy;

    return mgr;
}

#pragma mark - Verson 1

//1.	【发送（注册）手机验证码】
- (void)signCodeByMobile:(NSString *)mobile progressBlock:(ProgressBlock)progress success:(SuccessBlock)success failure:(FailureBlcok)failure{
    _url = [NSString stringWithFormat:@"%@/v1/sms/send",kHttpHeader];
    AFHTTPSessionManager *manager = [self creatManager];
    _dict = [NSDictionary dictionaryWithObjectsAndKeys:mobile,@"mobile", nil];
    [manager POST:_url parameters:_dict progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}
//2.	【登录注册：验证手机验证码,并登陆（新用户直接注册）】
- (void)chackCodeByMobile:(NSString *)mobile code:(NSString *)code progressBlock:(ProgressBlock)progress success:(SuccessBlock)success failure:(FailureBlcok)failure{
    _url = [NSString stringWithFormat:@"%@/v1/sms/check_code_login",kHttpHeader];
    AFHTTPSessionManager *manager = [self creatManager];
    _dict = [NSDictionary dictionaryWithObjectsAndKeys:mobile,@"mobile",code,@"code", nil];
    [manager POST:_url parameters:_dict progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

//3.	【版本：获取最新版本】
- (void)chackVersonProgressBlock:(ProgressBlock)progress success:(SuccessBlock)success failure:(FailureBlcok)failure{
    _url = [NSString stringWithFormat:@"%@/v1/version/release",kHttpHeader];
    AFHTTPSessionManager *manager = [self creatManager];
    [manager POST:_url parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

//4.	【授权：设备是否已授权信息】
- (void)empowerByUserId:(NSString *)userId udid:(NSString *)udid progressBlock:(ProgressBlock)progress success:(SuccessBlock)success failure:(FailureBlcok)failure{
    _url = [NSString stringWithFormat:@"%@/v1/user/auth_status",kHttpHeader];
    AFHTTPSessionManager *manager = [self creatManager];
    _dict = [NSDictionary dictionaryWithObjectsAndKeys:userId,@"id",udid,@"udid", nil];
    [manager POST:_url parameters:_dict progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

//5.	【授权：使用授权码绑定设备】
- (void)empowerAuthCodeByUserId:(NSString *)userId auth_code:(NSString *)auth_code udid:(NSString *)udid equipment_type:(NSString *)equipment_type progressBlock:(ProgressBlock)progress success:(SuccessBlock)success failure:(FailureBlcok)failure{
    _url = [NSString stringWithFormat:@"%@/v1/user/bind_equipment_code",kHttpHeader];
    AFHTTPSessionManager *manager = [self creatManager];
    _dict = [NSDictionary dictionaryWithObjectsAndKeys:userId,@"id",udid,@"udid",auth_code,@"auth_code",equipment_type,@"equipment_type", nil];
    [manager POST:_url parameters:_dict progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

//6.	【标签：获取所有标签】
- (void)getAllCityByUserId:(NSString *)userId udid:(NSString *)udid progressBlock:(ProgressBlock)progress success:(SuccessBlock)success failure:(FailureBlcok)failure{
    _url = [NSString stringWithFormat:@"%@/v1/label/page",kHttpHeader];
    AFHTTPSessionManager *manager = [self creatManager];
    _dict = [NSDictionary dictionaryWithObjectsAndKeys:userId,@"id",udid,@"udid", nil];
    [manager POST:_url parameters:_dict progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

//7.	【视频：获取指定条件下的分页视频】
- (void)getVideosByUserId:(NSString *)userId udid:(NSString *)udid label_id:(NSString *)label_id title:(NSString *)title page_index:(NSString *)page_index page_size:(NSString *)page_size progressBlock:(ProgressBlock)progress success:(SuccessBlock)success failure:(FailureBlcok)failure{
    _url = [NSString stringWithFormat:@"%@/v1/video/page",kHttpHeader];
    AFHTTPSessionManager *manager = [self creatManager];
    _dict = [NSDictionary dictionaryWithObjectsAndKeys:userId,@"id",udid,@"udid",label_id,@"label_id",title,@"title",page_index,@"page_index",page_size,@"page_size", nil];
    [manager POST:_url parameters:_dict progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

//7.	【视频：获取指定条件下的分页视频】-> 搜索
- (void)getSearchVideosByUserId:(NSString *)userId udid:(NSString *)udid title:(NSString *)title page_index:(NSString *)page_index page_size:(NSString *)page_size progressBlock:(ProgressBlock)progress success:(SuccessBlock)success failure:(FailureBlcok)failure{
    _url = [NSString stringWithFormat:@"%@/v1/video/page",kHttpHeader];
    AFHTTPSessionManager *manager = [self creatManager];
    _dict = [NSDictionary dictionaryWithObjectsAndKeys:userId,@"id",udid,@"udid",title,@"title",page_index,@"page_index",page_size,@"page_size", nil];
    [manager POST:_url parameters:_dict progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

#pragma mark - 我的新加
//1.	【个人中心（不区分用户类型）】
- (void)getMineMainInfoByUserId:(NSString *)user_id progressBlock:(ProgressBlock)progress success:(SuccessBlock)success failure:(FailureBlcok)failure{
    _url = [NSString stringWithFormat:@"%@/v1/ibeacon/me_info",kHttpHeader];
    AFHTTPSessionManager *manager = [self creatManager];
    _dict = [NSDictionary dictionaryWithObjectsAndKeys:user_id,@"user_id", nil];
    [manager POST:_url parameters:_dict progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

//2.	【根据二维码解析结果查找盒子】
- (void)readQRCodeToFindBoxByUserId:(NSString *)user_id rand_string:(NSString *)rand_string progressBlock:(ProgressBlock)progress success:(SuccessBlock)success failure:(FailureBlcok)failure{
    _url = [NSString stringWithFormat:@"%@/v1/ibeacon/query_by_string",kHttpHeader];
    AFHTTPSessionManager *manager = [self creatManager];
    _dict = [NSDictionary dictionaryWithObjectsAndKeys:user_id,@"user_id",rand_string,@"rand_string", nil];
    [manager POST:_url parameters:_dict progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}


//3.	【给用户绑定盒子】
- (void)bindBoxByUserId:(NSString *)user_id boxId:(NSString *)boxId progressBlock:(ProgressBlock)progress success:(SuccessBlock)success failure:(FailureBlcok)failure{
    _url = [NSString stringWithFormat:@"%@/v1/ibeacon/bind",kHttpHeader];
    AFHTTPSessionManager *manager = [self creatManager];
    _dict = [NSDictionary dictionaryWithObjectsAndKeys:user_id,@"user_id",boxId,@"id", nil];
    [manager POST:_url parameters:_dict progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

//4.	【更新盒子别名】
- (void)updateBoxNameByUserId:(NSString *)user_id boxId:(NSString *)boxId name:(NSString *)name progressBlock:(ProgressBlock)progress success:(SuccessBlock)success failure:(FailureBlcok)failure{
    _url = [NSString stringWithFormat:@"%@/v1/ibeacon/update_name",kHttpHeader];
    AFHTTPSessionManager *manager = [self creatManager];
    _dict = [NSDictionary dictionaryWithObjectsAndKeys:user_id,@"user_id",boxId,@"id",name,@"name", nil];
    [manager POST:_url parameters:_dict progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

//5.	【创建红包】
- (void)creatRedPacketByUserId:(NSString *)user_id
                          name:(NSString *)name
                   small_title:(NSString *)small_title
                        remark:(NSString *)remark
                      logo_url:(NSString *)logo_url
                       img_url:(NSString *)img_url
               red_price_fixed:(NSString *)red_price_fixed
                   total_count:(NSString *)total_count
                   total_price:(NSString *)total_price
                 progressBlock:(ProgressBlock)progress success:(SuccessBlock)success failure:(FailureBlcok)failure{
    _url = [NSString stringWithFormat:@"%@/v3/advertisement/add_new",kHttpHeader];
    AFHTTPSessionManager *manager = [self creatManager];
    _dict = [[NSDictionary alloc] initWithObjectsAndKeys:user_id,@"user_id",
             small_title,@"small_title",
             name,@"name",
             remark,@"remark",
             logo_url,@"logo_url",
             img_url,@"img_url",
             red_price_fixed,@"red_price_fixed",
             total_count,@"total_count",
             total_price,@"total_price", nil];
    [manager POST:_url parameters:_dict progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

//6.	【分页我的红包】
- (void)myRedPacketByUserId:(NSString *)user_id page_index:(NSString *)page_index page_size:(NSString *)page_size progressBlock:(ProgressBlock)progress success:(SuccessBlock)success failure:(FailureBlcok)failure{
    _url = [NSString stringWithFormat:@"%@/v3/advertisement/page",kHttpHeader];
    AFHTTPSessionManager *manager = [self creatManager];
    _dict = [[NSDictionary alloc] initWithObjectsAndKeys:user_id,@"user_id",page_index,@"page_index",page_size,@"page_size", nil];
    [manager POST:_url parameters:_dict progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

//7.	【支付宝--红包支付】
- (void)payRedpacketByAlipayByUserId:(NSString *)user_id adId:(NSString *)adId progressBlock:(ProgressBlock)progress success:(SuccessBlock)success failure:(FailureBlcok)failure{
    _url = [NSString stringWithFormat:@"%@/v3/transaction/alipay_advertisement_pay",kHttpHeader];
    AFHTTPSessionManager *manager = [self creatManager];
    _dict = [[NSDictionary alloc] initWithObjectsAndKeys:user_id,@"user_id",adId,@"id", nil];
    [manager POST:_url parameters:_dict progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

//8.	【发放红包—上下架】
- (void)redPacketStatusByUserId:(NSString *)user_id status:(NSString *)status adId:(NSString *)adId progressBlock:(ProgressBlock)progress success:(SuccessBlock)success failure:(FailureBlcok)failure{
    _url = [NSString stringWithFormat:@"%@/v3/advertisement/update_status",kHttpHeader];
    AFHTTPSessionManager *manager = [self creatManager];
    _dict = [[NSDictionary alloc] initWithObjectsAndKeys:user_id,@"user_id",adId,@"id",status,@"status", nil];
    [manager POST:_url parameters:_dict progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}


//9.删除红包
- (void)deletRedPacketByUserId:(NSString *)user_id adId:(NSString *)adId progressBlock:(ProgressBlock)progress success:(SuccessBlock)success failure:(FailureBlcok)failure{
    _url = [NSString stringWithFormat:@"%@/v3/advertisement/cancel",kHttpHeader];
    AFHTTPSessionManager *manager = [self creatManager];
    _dict = [[NSDictionary alloc] initWithObjectsAndKeys:user_id,@"user_id",adId,@"id", nil];
    [manager POST:_url parameters:_dict progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}
//10.	【微信大额提现：200至2000范围内】
- (void)getBigWithDrawalsByWeChatByUserid:(NSString *)user_id money:(NSString *)money progressBlock:(ProgressBlock)progress success:(SuccessBlock)success failure:(FailureBlcok)failure{
    _url = [NSString stringWithFormat:@"%@/v1/transaction/wechat_big_withdrawals",kHttpHeader];
    AFHTTPSessionManager *manager = [self creatManager];
    _dict = [NSDictionary dictionaryWithObjectsAndKeys:user_id,@"user_id",money,@"money", nil];
    [manager POST:_url parameters:_dict progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

//微信小额提现
- (void)getWIthDrawalsByWeChatByUserid:(NSString *)user_id money:(NSString *)money progressBlock:(ProgressBlock)progress success:(SuccessBlock)success failure:(FailureBlcok)failure{
    _url = [NSString stringWithFormat:@"%@/v1/transaction/wechat_withdrawals",kHttpHeader];
    AFHTTPSessionManager *manager = [self creatManager];
    _dict = [NSDictionary dictionaryWithObjectsAndKeys:user_id,@"user_id",money,@"money", nil];
    [manager POST:_url parameters:_dict progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

//我的余额
- (void)getMyMoneyByUserId:(NSString *)userId progressBlock:(ProgressBlock)progress success:(SuccessBlock)success failure:(FailureBlcok)failure{
    _url = [NSString stringWithFormat:@"%@/v1/user/balance",kHttpHeader];
    AFHTTPSessionManager *manager = [self creatManager];
    _dict = [NSDictionary dictionaryWithObjectsAndKeys:userId,@"id", nil];
    [manager POST:_url parameters:_dict progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

//13.	【微信：用户是否关联了微信账户】
- (void)isRelationWechatByUserId:(NSString *)userId progressBlock:(ProgressBlock)progress success:(SuccessBlock)success failure:(FailureBlcok)failure{
    _url = [NSString stringWithFormat:@"%@/v1/user/wx_status",kHttpHeader];
    AFHTTPSessionManager *manager = [self creatManager];
    _dict = [NSDictionary dictionaryWithObjectsAndKeys:userId,@"id", nil];
    [manager POST:_url parameters:_dict progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

//14.	【微信：用户关联绑定微信账户】
- (void)relationWechatByUserId:(NSString *)userId open_id:(NSString *)open_id unionid:(NSString *)unionid progressBlock:(ProgressBlock)progress success:(SuccessBlock)success failure:(FailureBlcok)failure{
    _url = [NSString stringWithFormat:@"%@/v1/user/bind_wx",kHttpHeader];
    AFHTTPSessionManager *manager = [self creatManager];
    _dict = [NSDictionary dictionaryWithObjectsAndKeys:userId,@"id",open_id,@"open_id",unionid,@"unionid", nil];
    [manager POST:_url parameters:_dict progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)errorCatchByUserId:(NSString *)user_id exception_info:(NSString *)exception_info progressBlock:(ProgressBlock)progress success:(SuccessBlock)success failure:(FailureBlcok)failure{
    _url = [NSString stringWithFormat:@"%@/v1/exception2/add",kHttpHeader];
    AFHTTPSessionManager *manager = [self creatManager];
    _dict = [NSDictionary dictionaryWithObjectsAndKeys:user_id,@"user_id",exception_info,@"exception_info", nil];
    [manager POST:_url parameters:_dict progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)hiddenViewProgressBlock:(ProgressBlock)progress success:(SuccessBlock)success failure:(FailureBlcok)failure{
    _url = [NSString stringWithFormat:@"%@/v1/config/examine_status",kHttpHeader];
    AFHTTPSessionManager *manager = [self creatManager];
    _dict = [NSDictionary dictionaryWithObjectsAndKeys:@"3",@"id", nil];
    [manager POST:_url parameters:_dict progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

#pragma mark - V2
//9.	【首页横幅所有】
- (void)getBunnerByUserId:(NSString *)userId udid:(NSString*)udid progressBlock:(ProgressBlock)progress success:(SuccessBlock)success failure:(FailureBlcok)failure{
    _url = [NSString stringWithFormat:@"%@/v2/banner/page",kHttpHeader];
    AFHTTPSessionManager *manager = [self creatManager];
    _dict = [NSDictionary dictionaryWithObjectsAndKeys:userId,@"id",udid ,@"udid", nil];
    [manager POST:_url parameters:_dict progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

//10.	【图片素材标签：获取所有标签】
- (void)getPictureLabelsByUserId:(NSString *)userId udid:(NSString*)udid progressBlock:(ProgressBlock)progress success:(SuccessBlock)success failure:(FailureBlcok)failure{
    _url = [NSString stringWithFormat:@"%@/v2/material_label/page",kHttpHeader];
    AFHTTPSessionManager *manager = [self creatManager];
    _dict = [NSDictionary dictionaryWithObjectsAndKeys:userId,@"id",udid ,@"udid", nil];
    [manager POST:_url parameters:_dict progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

//11.	【图片素材标签 下的素材：分页】
- (void)getPictureInfoByUserId:(NSString *)userId udid:(NSString *)udid material_label_id:(NSString *)material_label_id title:(NSString *)title page_index:(NSString *)page_index page_size:(NSString *)page_size progressBlock:(ProgressBlock)progress success:(SuccessBlock)success failure:(FailureBlcok)failure{
    _url = [NSString stringWithFormat:@"%@/v2/material_label_image/page",kHttpHeader];
    AFHTTPSessionManager *manager = [self creatManager];
    
    if ([BGFunctionHelper isNULLOfString:material_label_id]) {
        _dict = [NSDictionary dictionaryWithObjectsAndKeys:userId,@"id",udid ,@"udid",page_index ,@"page_index",page_size ,@"page_size", nil];
    }else{
        _dict = [NSDictionary dictionaryWithObjectsAndKeys:userId,@"id",udid ,@"udid",material_label_id ,@"material_label_id",page_index ,@"page_index",page_size ,@"page_size", nil];
    }
    [manager POST:_url parameters:_dict progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
