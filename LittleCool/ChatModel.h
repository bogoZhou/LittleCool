//
//  ChatModel.h
//  Qian
//
//  Created by 周博 on 17/2/14.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "BaseModel.h"

@interface ChatModel : BaseModel

@property (nonatomic,strong) NSString *chatRoomId;     //主键,和对象聊天房间的id

@property (nonatomic,strong) NSString *chatDetailId;//每条数据的id

//对象类型
//1- >自己文字;2 -> 对方文字;3->我转账;4->对方转账;5->我发红包;
//6->对方发红包;7->我图片;8->对方图片;9->我语音;10->对方语音;
//11->我撤回;12->对方撤回;13->我领取红包;14->对方领取红包
@property (nonatomic,strong) NSString *type;

//@property (nonatomic,strong) NSData *userImage;       //头像
@property (nonatomic,strong) NSString *content;            //聊天文字内容
@property (nonatomic,strong) NSString *lastTime;           //最后聊天时间
@property (nonatomic,strong) NSString *userId;        //用户名称
@property (nonatomic,strong) NSData *contentImage;
@end
