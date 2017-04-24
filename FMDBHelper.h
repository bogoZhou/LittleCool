//
//  FMDBHelper.h
//  Qian
//
//  Created by 周博 on 17/2/13.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDatabase.h>
#import <FMDatabaseQueue.h>
#import "UserInfoModel.h"
#import "ChatModel.h"
#import "ChatListModel.h"
#import "MoneyModel.h"
#import "FriendsModel.h"
#import "ZanModel.h"
#import "CommentModel2.h"
#import "BankCardModel.h"
#import "ChatRedPacketModel.h"
#import "GetRedUserModel.h"
#import "WechatPayModel.h"

@interface FMDBHelper : NSObject
{
    FMDatabase *db;
    NSString *database_path;
}

+ (FMDBHelper *)fmManger;

//创建fmdb文件
- (void)getFMDBBySQLName:(NSString *)sqlName;

//创建表
- (void)createTableByTableName:(NSString *)tableName;

//插入数据
-(void)insertMyUserInfoDataByTableName:(NSString *)tableName
                                    Id:(NSString *)Id
                                  name:(NSString *)name
                             headImage:(NSString *)headImage
                             wechatNum:(NSString *)wechatNum
                                 money:(NSString *)money;

-(void)insertOtherUserInfoDataByTableName:(NSString *)tableName
                                       Id:(NSString *)Id
                                     name:(NSString *)name
                                headImage:(NSString *)headImage
                                wechatNum:(NSString *)wechatNum
                                    money:(NSString *)money;

//更新数据
-(void)updateDataByTableName:(NSString *)tableName TypeName:(NSString *)TypeName typeValue0:(id)typeValue0 typeValue1:(NSString *)typeValue1 typeValue2:(NSString *)typeValue2;

//删除数据
-(void)deleteDataByTableName:(NSString *)tableName TypeName:(NSString *)TypeName TypeValue:(NSString *)typeValue;

//查找数据
-(NSMutableArray *)selectDataByTableName:(NSString *)tableName;

//查找user
-(NSMutableArray *)selectUserInfoDataByValueName:(NSString *)valueName value:(NSString *)value;


// 删除表
- (void)deleteTable:(NSString *)tableName;

//创建头像表
- (void)creatImageTable;

//插入头像内容
-(void)insertDataByTableName:(NSString *)tableName
                   headImage:(NSString *)headImage
                imageAddress:(NSString *)imageAddresss;

//查头像表
-(NSMutableArray *)selectImageDataByTableName:(NSString *)tableName;

#pragma mark - 聊天列表
- (void)creatChatListTable;

-(void)insertChatListByTableName:(NSString *)tableName
                        lastTime:(NSString *)lastTime
                    chatDetailId:(NSString *)chatDetailId
                          isNoti:(NSString *)isNoti
                       userImage:(NSString *)userImage
                        userName:(NSString *)userName
                     lastContent:(NSString *)lastContent
                          userId:(NSString *)userId;

-(NSMutableArray *)selectChatListWhereValue1:(NSString *)value1 value2:(NSString *)value2 isNeed:(BOOL)isNeed;

#pragma mark - 聊天详情表
- (void)creatChatDetailTable;

-(void)insertChatDetailByTableName:(NSString *)tableName
                        chatRoomId:(NSString *)chatRoomId
                          lastTime:(NSString *)lastTime
                         userImage:(NSString *)userImage
                          userName:(NSString *)userName
                           content:(NSString *)content
                              type:(NSString *)type
                      contentImage:(NSString *)contentImage;

-(NSMutableArray *)selectChatDetailWhereValue1:(NSString *)value1 value2:(NSString *)value2;

#pragma mark - 零钱明细表

- (void)createMoneyTable;

-(void)insertMoneyDataByName:(NSString *)name
                        type:(NSString *)type
                        date:(NSString *)date
                       money:(NSString *)money;

-(NSMutableArray *)selectMoneyWhereValue1:(NSString *)value1 value2:(NSString *)value2 isNeed:(BOOL)isNeed;

#pragma mark - 朋友圈表

- (void)createFriendsTable;

-(void)insertFriendsDataByUserId:(NSString *)userId
                     textContent:(NSString *)textContent
                            date:(NSString *)date;

-(NSMutableArray *)selectFriendsWhereValue1:(NSString *)value1 value2:(NSString *)value2 isNeed:(BOOL)isNeed;

#pragma mark - 赞表
- (void)createZanTable;

-(void)insertZanDataByFriendsId:(NSString *)friendsId
                         userId:(NSString *)userId;

-(NSMutableArray *)selectZanWhereValue1:(NSString *)value1 value2:(NSString *)value2 isNeed:(BOOL)isNeed;

-(NSMutableArray *)selectRandomZanWithNum:(NSString *)num;
#pragma mark - 评论表
- (void)createCommentTable;

-(void)insertCommentDataByFriendsId:(NSString *)friendsId
                          isFriends:(NSString *)isFriends
                         fromUserId:(NSString *)fromUserId
                           toUserId:(NSString *)toUserId
                     commentContent:(NSString *)commentContent;

-(NSMutableArray *)selectCommentWhereValue1:(NSString *)value1 value2:(NSString *)value2 isNeed:(BOOL)isNeed;

#pragma mark - 朋友圈图片表

- (void)createImagesTable;

-(void)insertFriendsImagesDataByFriendsId:(NSString *)friendsId image:(NSString *)image;

-(NSMutableArray *)selectFriendsImageWhereValue1:(NSString *)value1 value2:(NSString *)value2 isNeed:(BOOL)isNeed;

#pragma mark - 银行卡表
- (void)createBankTable;

-(void)insertBankDataByBankName:(NSString *)bankName
                        bankNum:(NSString *)bankNum;

-(NSMutableArray *)selectBankCardWhereValue1:(NSString *)value1 value2:(NSString *)value2 isNeed:(BOOL)isNeed;

#pragma mark - 聊天红包表

- (void)createRedPacketTable;

-(void)insertRedPacketByRedMoney:(NSString *)redMoney
                 redSurplusMoney:(NSString *)redSurplusMoney
                          redNum:(NSString *)redNum
                   redSurplusNum:(NSString *)redSurplusNum
                       creatDate:(NSString *)creatDate
                         endDate:(NSString *)endDate
                      redContent:(NSString *)redContent;

-(NSMutableArray *)selectRedPacketWhereValue1:(NSString *)value1 value2:(NSString *)value2 isNeed:(BOOL)isNeed;

#pragma mark - 抢红包用户表

- (void)createGetRedPacketUserTable;

-(void)insertGetRedPacketUserByUserId:(NSString *)userId
                                redId:(NSString *)redId
                          getMoneyNum:(NSString *)getMoneyNum
                         getMoneyDate:(NSString *)getMoneyDate
                              isGreat:(NSString *)isGreat;

-(NSMutableArray *)selectGetRedPacketUserWhereValue1:(NSString *)value1 value2:(NSString *)value2 isNeed:(BOOL)isNeed;

#pragma mark - 微信支付表

- (void)createWechatPayUserTable;

-(void)insertWechatPayUserByType:(NSString *)type
                           money:(NSString *)money
                       startDate:(NSString *)startDate
                         endDate:(NSString *)endDate
                          remark:(NSString *)remark
                          reason:(NSString *)reason
                        userName:(NSString *)userName;

-(NSMutableArray *)selectWechatPayUserWhereValue1:(NSString *)value1 value2:(NSString *)value2 isNeed:(BOOL)isNeed;


@end
