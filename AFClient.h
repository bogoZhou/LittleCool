//
//  AFClient.h
//  noteMan
//
//  Created by 周博 on 16/12/12.
//  Copyright © 2016年 BogoZhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#if 0
//线下

#define kHttpHeader @"https://192.168.16.133:5000/flash_help/app"
//https://192.168.16.134
#else
//线上
//https:// 139.196.18.81/truelies_video
#define kHttpHeader @"http://www.sprxt.com/truelies_video/app"
#endif
@interface AFClient : NSObject

typedef void(^ProgressBlock)(NSProgress *progress);
typedef void(^SuccessBlock)(id responseBody);
typedef void(^FailureBlcok)(NSError *error);

@property (nonatomic,strong)ProgressBlock progressBolck;
@property (nonatomic,strong)SuccessBlock successBlock;
@property (nonatomic,strong)FailureBlcok failureBlock;


+(instancetype)shareInstance;

#pragma mark - Verson 1

//1.	【登录注册：发送手机验证码（登录使用）】
- (void)signCodeByMobile:(NSString *)mobile progressBlock:(ProgressBlock)progress success:(SuccessBlock)success failure:(FailureBlcok)failure;

//2.	【登录注册：验证手机验证码,并登陆（新用户直接注册）】
- (void)chackCodeByMobile:(NSString *)mobile code:(NSString *)code progressBlock:(ProgressBlock)progress success:(SuccessBlock)success failure:(FailureBlcok)failure;

//3.	【版本：获取最新版本】
- (void)chackVersonProgressBlock:(ProgressBlock)progress success:(SuccessBlock)success failure:(FailureBlcok)failure;

//4.	【授权：设备是否已授权信息】
- (void)empowerByUserId:(NSString *)userId udid:(NSString *)udid progressBlock:(ProgressBlock)progress success:(SuccessBlock)success failure:(FailureBlcok)failure;

//5.	【授权：使用授权码绑定设备】
- (void)empowerAuthCodeByUserId:(NSString *)userId auth_code:(NSString *)auth_code udid:(NSString *)udid equipment_type:(NSString *)equipment_type progressBlock:(ProgressBlock)progress success:(SuccessBlock)success failure:(FailureBlcok)failure;

//6.	【标签：获取所有标签】
- (void)getAllCityByUserId:(NSString *)userId udid:(NSString *)udid progressBlock:(ProgressBlock)progress success:(SuccessBlock)success failure:(FailureBlcok)failure;

//7.	【视频：获取指定条件下的分页视频】
- (void)getVideosByUserId:(NSString *)userId udid:(NSString *)udid label_id:(NSString *)label_id title:(NSString *)title page_index:(NSString *)page_index page_size:(NSString *)page_size progressBlock:(ProgressBlock)progress success:(SuccessBlock)success failure:(FailureBlcok)failure;

//7.	【视频：获取指定条件下的分页视频】-> 搜索
- (void)getSearchVideosByUserId:(NSString *)userId udid:(NSString *)udid title:(NSString *)title page_index:(NSString *)page_index page_size:(NSString *)page_size progressBlock:(ProgressBlock)progress success:(SuccessBlock)success failure:(FailureBlcok)failure;

#pragma mark - 我的新加
//1.	【个人中心（不区分用户类型）】
- (void)getMineMainInfoByUserId:(NSString *)user_id progressBlock:(ProgressBlock)progress success:(SuccessBlock)success failure:(FailureBlcok)failure;

//2.	【根据二维码解析结果查找盒子】
- (void)readQRCodeToFindBoxByUserId:(NSString *)user_id rand_string:(NSString *)rand_string progressBlock:(ProgressBlock)progress success:(SuccessBlock)success failure:(FailureBlcok)failure;

//3.	【给用户绑定盒子】
- (void)bindBoxByUserId:(NSString *)user_id boxId:(NSString *)boxId progressBlock:(ProgressBlock)progress success:(SuccessBlock)success failure:(FailureBlcok)failure;

//4.	【更新盒子别名】
- (void)updateBoxNameByUserId:(NSString *)user_id boxId:(NSString *)boxId name:(NSString *)name progressBlock:(ProgressBlock)progress success:(SuccessBlock)success failure:(FailureBlcok)failure;

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
                 progressBlock:(ProgressBlock)progress success:(SuccessBlock)success failure:(FailureBlcok)failure;

//6.	【分页我的红包】
- (void)myRedPacketByUserId:(NSString *)user_id page_index:(NSString *)page_index page_size:(NSString *)page_size progressBlock:(ProgressBlock)progress success:(SuccessBlock)success failure:(FailureBlcok)failure;

//7.	【支付宝--红包支付】
- (void)payRedpacketByAlipayByUserId:(NSString *)user_id adId:(NSString *)adId progressBlock:(ProgressBlock)progress success:(SuccessBlock)success failure:(FailureBlcok)failure;

//8.	【发放红包—上下架】
- (void)redPacketStatusByUserId:(NSString *)user_id status:(NSString *)status adId:(NSString *)adId progressBlock:(ProgressBlock)progress success:(SuccessBlock)success failure:(FailureBlcok)failure;


//9.删除红包
- (void)deletRedPacketByUserId:(NSString *)user_id adId:(NSString *)adId progressBlock:(ProgressBlock)progress success:(SuccessBlock)success failure:(FailureBlcok)failure;

//10.	【微信大额提现：200至2000范围内】
- (void)getBigWithDrawalsByWeChatByUserid:(NSString *)user_id money:(NSString *)money progressBlock:(ProgressBlock)progress success:(SuccessBlock)success failure:(FailureBlcok)failure;

//微信提现小额提现
- (void)getWIthDrawalsByWeChatByUserid:(NSString *)user_id money:(NSString *)money progressBlock:(ProgressBlock)progress success:(SuccessBlock)success failure:(FailureBlcok)failure;

//我的余额
- (void)getMyMoneyByUserId:(NSString *)userId progressBlock:(ProgressBlock)progress success:(SuccessBlock)success failure:(FailureBlcok)failure;

//13.	【微信：用户是否关联了微信账户】
- (void)isRelationWechatByUserId:(NSString *)userId progressBlock:(ProgressBlock)progress success:(SuccessBlock)success failure:(FailureBlcok)failure;

//14.	【微信：用户关联绑定微信账户】
- (void)relationWechatByUserId:(NSString *)userId open_id:(NSString *)open_id unionid:(NSString *)unionid progressBlock:(ProgressBlock)progress success:(SuccessBlock)success failure:(FailureBlcok)failure;

- (void)errorCatchByUserId:(NSString *)user_id exception_info:(NSString *)exception_info progressBlock:(ProgressBlock)progress success:(SuccessBlock)success failure:(FailureBlcok)failure;

- (void)hiddenViewProgressBlock:(ProgressBlock)progress success:(SuccessBlock)success failure:(FailureBlcok)failure;

#pragma mark - V2
//9.	【首页横幅所有】
- (void)getBunnerByUserId:(NSString *)userId udid:(NSString*)udid progressBlock:(ProgressBlock)progress success:(SuccessBlock)success failure:(FailureBlcok)failure;

//10.	【图片素材标签：获取所有标签】
- (void)getPictureLabelsByUserId:(NSString *)userId udid:(NSString*)udid progressBlock:(ProgressBlock)progress success:(SuccessBlock)success failure:(FailureBlcok)failure;

//11.	【图片素材标签 下的素材：分页】
- (void)getPictureInfoByUserId:(NSString *)userId udid:(NSString *)udid material_label_id:(NSString *)material_label_id title:(NSString *)title page_index:(NSString *)page_index page_size:(NSString *)page_size progressBlock:(ProgressBlock)progress success:(SuccessBlock)success failure:(FailureBlcok)failure;

//12.	【仿微信：获取指定数量的用户】
- (void)getRandomUserByCounts:(NSString *)counts progressBlock:(ProgressBlock)progress success:(SuccessBlock)success failure:(FailureBlcok)failure;


#pragma mark - 海报制作
//13.	【海报模板：获取标签和海报（不含详情）】
- (void)posterGetLabelsMubanById:(NSString *)userId udid:(NSString *)udid progressBlock:(ProgressBlock)progress success:(SuccessBlock)success failure:(FailureBlcok)failure;

//14.	【海报模板：获取详细制作数据】
- (void)getPosterDetailByUserId:(NSString *)userId udid:(NSString *)udid material_id:(NSString *)material_id progressBlock:(ProgressBlock)progress success:(SuccessBlock)success failure:(FailureBlcok)failure;
@end
