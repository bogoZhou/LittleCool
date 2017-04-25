//
//  ChatListModel.h
//  Qian
//
//  Created by 周博 on 17/2/14.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "BaseModel.h"

@interface ChatListModel : BaseModel

@property (nonatomic,strong) NSString *chatRoomId;      //主键,聊天列表的id
@property (nonatomic,strong) NSString *chatDetailId;     //副键,和对象聊天房间的id
@property (nonatomic,strong) NSString *lastTime;           //聊天最后时间
@property (nonatomic,strong) NSData *userImage;       //聊天对象头像
@property (nonatomic,strong) NSString *userName;        //聊天对象名字
@property (nonatomic,strong) NSString *isNoti;              //是否显示通知
@property (nonatomic,strong) NSString *lastContent;     //聊天最后内容

@property (nonatomic,strong) NSString *userId;              //聊天对象id
@property (nonatomic,strong) NSString *redNum;             //小红点个数
@end
