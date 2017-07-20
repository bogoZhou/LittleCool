//
//  CommentModel2.h
//  Qian
//
//  Created by 周博 on 17/2/19.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "BaseModel.h"

@interface CommentModel2 : BaseModel

@property (nonatomic,strong) NSString *friendsId;
@property (nonatomic,strong) NSString *isFriends;
@property (nonatomic,strong) NSString *fromUserId;
@property (nonatomic,strong) NSString *toUserId;
@property (nonatomic,strong) NSString *commentContent;

@end
