//
//  FMDBHelper.m
//  Qian
//
//  Created by 周博 on 17/2/13.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "FMDBHelper.h"

#define DBNAME    @"personinfo.sqlite"
#define IMAGEDB @"imageDB.sqlite"
#define ID        @"Id"
#define NAME      @"name"
#define HEADIMAGE       @"headImage"
#define WECHATNUM   @"wechatNum"
#define MONEY @"money"
#define TABLENAME @"PERSONINFO"
#define IMAGEADDRESS @"imageAddress"

static FMDBHelper *fmManager = nil;

@interface FMDBHelper ()
{
    
}

@end

@implementation FMDBHelper

+ (FMDBHelper *)fmManger{
    if (!fmManager) {
        fmManager = [[FMDBHelper allocWithZone:NULL] init];
    }
    return fmManager;
}

- (void)getFMDBBySQLName:(NSString *)sqlName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths objectAtIndex:0];
    database_path = [documents stringByAppendingPathComponent:sqlName];
    
    db = [FMDatabase databaseWithPath:database_path];
}

#pragma mark - 创建用户表

- (void)createTableByTableName:(NSString *)tableName
{
    //sql 语句
    if ([db open]) {
        NSString *sqlCreateTable =  [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY AUTOINCREMENT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT)",tableName,ID,NAME,HEADIMAGE,WECHATNUM,MONEY];
        BOOL res = [db executeUpdate:sqlCreateTable];
        if (!res) {
            NSLog(@"error when creating db table");
        } else {
            NSLog(@"success to creating db table");
        }
        //[db close];
        
    }
}



-(void)insertMyUserInfoDataByTableName:(NSString *)tableName
                          Id:(NSString *)Id
                        name:(NSString *)name
                   headImage:(NSString *)headImage
                   wechatNum:(NSString *)wechatNum
                       money:(NSString *)money
{
    if ([db open]) {
        BOOL flag = [db executeUpdate:@"insert into userINFO (name,headImage,wechatNum,money) values(?,?,?,?)",name,headImage,wechatNum,money];

        if (!flag) {
            NSLog(@"error when insert db table");
        } else {
            NSLog(@"success to insert db table");
        }
        //[db close];
        
    }
    
}

-(void)insertOtherUserInfoDataByTableName:(NSString *)tableName
                          Id:(NSString *)Id
                        name:(NSString *)name
                   headImage:(NSString *)headImage
                   wechatNum:(NSString *)wechatNum
                       money:(NSString *)money
{
    if ([db open]) {
        BOOL flag = [db executeUpdate:@"insert into otherUserINFO (name,headImage,wechatNum,money) values(?,?,?,?)",name,headImage,wechatNum,money];
        
        if (!flag) {
            NSLog(@"error when insert db table");
        } else {
            NSLog(@"success to insert db table");
        }
        //[db close];
        
    }
    
}

-(void)updateDataByTableName:(NSString *)tableName TypeName:(NSString *)TypeName typeValue0:(id)typeValue0 typeValue1:(NSString *)typeValue1 typeValue2:(NSString *)typeValue2{
    if ([db open]) {
        NSString *updateSql = [NSString stringWithFormat:
                               @"UPDATE %@ SET %@ = '%@' WHERE %@ = '%@'",
                               tableName,   TypeName,  typeValue0 ,typeValue1,  typeValue2];
        
        BOOL res;
        if ([TypeName isEqualToString:@"headImage"]) {
            if ([tableName isEqualToString:kUserTable] && [typeValue0 class] != [NSString class]) {
                res = [db executeUpdate:@"update userINFO set headImage = ? where Id = 1",typeValue0];
                
            }else if ([tableName isEqualToString:kOthreUserTable] && [typeValue0 class] != [NSString class]){
                res = [db executeUpdate:@"update otherUserINFO set headImage = ? where Id = ?",typeValue0,typeValue2];
            }else if ([tableName isEqualToString:kChatListTable] && [typeValue0 class] != [NSString class]){
                res = [db executeUpdate:@"update chatList set userImage = ? where chatRoomId = ?",typeValue0,typeValue2];
            }
        }else{
            res = [db executeUpdate:updateSql];
        }
        
        if (!res) {
            NSLog(@"error when update db table");
        } else {
            NSLog(@"success to update db table");
        }
        //[db close];
        
    }
    
}

-(void)deleteDataByTableName:(NSString *)tableName TypeName:(NSString *)TypeName TypeValue:(NSString *)typeValue{
    if ([db open]) {
        
        NSString *deleteSql = [NSString stringWithFormat:
                               @"delete from %@ where %@ = '%@'",
                               tableName, TypeName, typeValue];
        BOOL res = [db executeUpdate:deleteSql];
        
        if (!res) {
            NSLog(@"error when delete db table");
        } else {
            NSLog(@"success to delete db table");
        }
        //[db close];
        
    }
    
}

// 删除表
- (void) deleteTable:(NSString *)tableName
{
    if ([db open]) {
        NSString *sqlstr = [NSString stringWithFormat:@"DROP TABLE %@", tableName];
        if (![db executeUpdate:sqlstr])
        {
            NSLog(@"Delete table error!");
        }
        //[db close];
    }
    
}

-(NSMutableArray *)selectDataByTableName:(NSString *)tableName
{
    NSMutableArray *array = [NSMutableArray array];
    if ([db open]) {
        NSString * sql = [NSString stringWithFormat:
                          @"SELECT * FROM %@",tableName];
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next]) {
//            NSString * IId =
//            NSString * name =
//            NSData * img = [rs dataForColumn:HEADIMAGE];
//            NSString * wechatN =
//            NSString * Money =
            
            UserInfoModel *model = [[UserInfoModel alloc] init];
            model.Id = [rs stringForColumn:ID];
            model.name = [rs stringForColumn:NAME];
            model.headImage = [rs stringForColumn:HEADIMAGE];
            model.wechatNum = [rs stringForColumn:WECHATNUM];
            model.money = [rs stringForColumn:MONEY];
                        
            [array addObject:model];
            
//            NSLog(@"id = %@, name = %@, img = %@  wechatN = %@ money = %@", IId, name, img, wechatN,Money);
        }
        //[db close];
    }
    return array;
}

-(NSMutableArray *)selectUserInfoDataByValueName:(NSString *)valueName value:(NSString *)value
{
    NSMutableArray *array = [NSMutableArray array];
    if ([db open]) {
        NSString * sql = [NSString stringWithFormat:
                          @"SELECT * FROM otherUserINFO where %@ = '%@'",valueName,value];
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next]) {
            UserInfoModel *model = [[UserInfoModel alloc] init];
            model.Id = [rs stringForColumn:ID];
            model.name = [rs stringForColumn:NAME];
            model.headImage = [rs stringForColumn:HEADIMAGE];
            model.wechatNum = [rs stringForColumn:WECHATNUM];
            model.money = [rs stringForColumn:MONEY];
            
            [array addObject:model];
            
            //            NSLog(@"id = %@, name = %@, img = %@  wechatN = %@ money = %@", IId, name, img, wechatN,Money);
        }
        //[db close];
    }
    return array;
}

#pragma mark - 创建头像表

- (void)creatImageTable{
    //sql 语句
    if ([db open]) {
        NSString *sqlCreateTable =  [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY AUTOINCREMENT, '%@' TEXT)",kImageTable,ID,IMAGEADDRESS];
        BOOL res = [db executeUpdate:sqlCreateTable];
        if (!res) {
            NSLog(@"error when creating db table");
        } else {
            NSLog(@"success to creating db table");
        }
        //[db close];
    }
}

-(void)insertDataByTableName:(NSString *)tableName
                        headImage:(NSString *)headImage
                   imageAddress:(NSString *)imageAddresss
{
    if ([db open]) {
        NSString *insertSql1= [NSString stringWithFormat:
                               @"INSERT INTO '%@' ('%@') VALUES ('%@')",
                               tableName,IMAGEADDRESS,imageAddresss];
        BOOL res = [db executeUpdate:insertSql1];
        
        if (!res) {
            NSLog(@"error when insert db table");
        } else {
            NSLog(@"success to insert db table");
        }
        //[db close];
        
    }
    
}

-(NSMutableArray *)selectImageDataByTableName:(NSString *)tableName
{
    NSMutableArray *array = [NSMutableArray array];
    if ([db open]) {
        NSString * sql = [NSString stringWithFormat:
                          @"SELECT * FROM %@",tableName];
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next]) {

            NSString *imagePath = [rs stringForColumn:IMAGEADDRESS];
            
            [array addObject:imagePath];
            
            //            NSLog(@"id = %@, name = %@, img = %@  wechatN = %@ money = %@", IId, name, img, wechatN,Money);
        }
        //[db close];
    }
    return array;
}

#pragma mark - 聊天列表 表
- (void)creatChatListTable{
    //sql 语句
    if ([db open]) {
        NSString *sqlCreateTable =  [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY AUTOINCREMENT,  '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' blob, '%@' TEXT,  '%@' TEXT,'%@' text,'%@' text)",kChatListTable,@"chatRoomId",@"chatDetailId",@"lastTime",@"isNoti",@"userImage",@"userName",@"lastContent",@"userId",@"redNum"];

        
        BOOL res = [db executeUpdate:sqlCreateTable];
        if (!res) {
            NSLog(@"error when creating db table");
        } else {
            NSLog(@"success to creating db table");
        }
        //[db close];
    }
}

-(void)insertChatListByTableName:(NSString *)tableName
                       lastTime:(NSString *)lastTime
                        chatDetailId:(NSString *)chatDetailId
                    isNoti:(NSString *)isNoti
                       userImage:(NSString *)userImage
                    userName:(NSString *)userName
                       lastContent:(NSString *)lastContent
                          userId:(NSString *)userId
{
    if ([db open]) {
//        NSString *insertSql1= [NSString stringWithFormat:
//                               @"INSERT INTO '%@' ('%@','%@','%@','%@','%@','%@') VALUES ('%@','%@','%@','%@','%@','%@')",
//                               tableName,@"lastTime",@"isNoti",@"userImage",@"userName",@"lastContent",@"chatDetailId",lastTime,isNoti,userImage,userName,lastContent,chatDetailId];
        
        BOOL flag = [db executeUpdate:@"insert into chatList (chatDetailId,lastTime,isNoti,userImage,userName,lastContent,userId) values(?,?,?,?,?,?,?)",chatDetailId,lastTime,isNoti,userImage,userName,lastContent,userId];
        
//        BOOL res = [db executeUpdate:insertSql1];
        
        if (!flag) {
            NSLog(@"error when insert db table");
        } else {
            NSLog(@"success to insert db table");
        }
        //[db close];
        
    }
    
}

-(NSMutableArray *)selectChatListWhereValue1:(NSString *)value1 value2:(NSString *)value2 isNeed:(BOOL)isNeed
{
    NSMutableArray *array = [NSMutableArray array];
    if ([db open]) {
        NSString * sql ;
        if (isNeed) {
            sql = [NSString stringWithFormat:
                   @"SELECT * FROM %@ WHERE %@='%@'",kChatListTable,value1,value2];
        }else{
            sql = [NSString stringWithFormat:
                              @"SELECT * FROM %@",kChatListTable];
        }
        
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next]) {
            ChatListModel *model = [[ChatListModel alloc] init];
            model.chatRoomId = [rs stringForColumn:@"chatRoomId"];
            model.chatDetailId = [rs stringForColumn:@"chatDetailId"];
            model.lastTime = [rs stringForColumn:@"lastTime"];
            model.isNoti = [rs stringForColumn:@"isNoti"];
            model.userImage = [rs stringForColumn:@"userImage"];
            model.userName = [rs stringForColumn:@"userName"];
            model.lastContent = [rs stringForColumn:@"lastContent"];
            model.userId = [rs stringForColumn:@"userId"];
            model.redNum = [rs stringForColumn:@"redNum"];
            [array addObject:model];
        }
        //[db close];
    }
    return array;
}

#pragma mark - 聊天详情列表

- (void)creatChatDetailTable{
    //sql 语句
    if ([db open]) {
        NSString *sqlCreateTable =  [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY AUTOINCREMENT, '%@' TEXT, '%@' TEXT,'%@' TEXT, '%@' blob, '%@' TEXT, '%@' TEXT,'%@',blob)",kChatDetailTable,@"chatDetailId",@"chatRoomId",@"lastTime",@"type",@"userImage",@"userName",@"content",@"contentImage"];
        BOOL res = [db executeUpdate:sqlCreateTable];
        if (!res) {
            NSLog(@"error when creating db table");
        } else {
            NSLog(@"success to creating db table");
        }
        //[db close];
    }
}

-(void)insertChatDetailByTableName:(NSString *)tableName
                    chatRoomId:(NSString *)chatRoomId
                        lastTime:(NSString *)lastTime
                       userImage:(NSString *)userImage
                        userName:(NSString *)userName
                        content:(NSString *)content
                     type:(NSString *)type
                      contentImage:(NSString *)contentImage
{
    if ([db open]) {
//        NSString *insertSql1= [NSString stringWithFormat:
//                               @"INSERT INTO '%@' ('%@','%@','%@','%@','%@','%@') VALUES ('%@','%@','%@','%@','%@','%@')",
//                               tableName,@"chatRoomId",@"lastTime",@"userImage",@"userName",@"type",@"content",chatRoomId,lastTime,userImage,userName,type,content];
        
        BOOL flag = [db executeUpdate:@"insert into chatDetail (chatRoomId,lastTime,userImage,userName,type,content,contentImage) values(?,?,?,?,?,?,?)",chatRoomId,lastTime,userImage,userName,type,content,contentImage];
        
//        BOOL res = [db executeUpdate:insertSql1];
        
        if (!flag) {
            NSLog(@"error when insert db table");
        } else {
            NSLog(@"success to insert db table");
        }
        //[db close];
        
    }
    
}

-(NSMutableArray *)selectChatDetailWhereValue1:(NSString *)value1 value2:(NSString *)value2
{
    NSMutableArray *array = [NSMutableArray array];
    if ([db open]) {
        NSString * sql = [NSString stringWithFormat:
                          @"SELECT * FROM %@ WHERE %@='%@'",kChatDetailTable,value1,value2];
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next]) {
            ChatModel *model = [[ChatModel alloc] init];
            model.chatRoomId = [rs stringForColumn:@"chatRoomId"];
            model.lastTime = [rs stringForColumn:@"lastTime"];
            model.userImage = [rs stringForColumn:@"userImage"];
            model.userName = [rs stringForColumn:@"userName"];
            model.content = [rs stringForColumn:@"content"];
            model.type = [rs stringForColumn:@"type"];
            model.contentImage = [rs stringForColumn:@"contentImage"];
            model.chatDetailId = [rs stringForColumn:@"chatDetailId"];
            [array addObject:model];
        }
        //[db close];
    }
    return array;
}

#pragma mark - 零钱明细表

- (void)createMoneyTable
{
    //sql 语句
    if ([db open]) {
        NSString *sqlCreateTable =  [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY AUTOINCREMENT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT)",kMoneyTable,@"Id",@"name",@"type",@"money",@"date"];
        BOOL res = [db executeUpdate:sqlCreateTable];
        if (!res) {
            NSLog(@"error when creating db table");
        } else {
            NSLog(@"success to creating db table");
        }
        //[db close];
        
    }
}

-(void)insertMoneyDataByName:(NSString *)name
                   type:(NSString *)type
                   date:(NSString *)date
                       money:(NSString *)money
{
    if ([db open]) {
        NSString *insertSql1= [NSString stringWithFormat:
                               @"INSERT INTO '%@' ('%@', '%@','%@','%@') VALUES ('%@', '%@', '%@','%@')",
                               kMoneyTable, @"name", @"type", @"money", @"date", name, type, money,date];
        BOOL res = [db executeUpdate:insertSql1];
        
        if (!res) {
            NSLog(@"error when insert db table");
        } else {
            NSLog(@"success to insert db table");
        }
        //[db close];
        
    }
    
}

-(NSMutableArray *)selectMoneyWhereValue1:(NSString *)value1 value2:(NSString *)value2 isNeed:(BOOL)isNeed
{
    NSMutableArray *array = [NSMutableArray array];
    if ([db open]) {
        NSString * sql ;
        if (isNeed) {
            sql = [NSString stringWithFormat:
                   @"SELECT * FROM %@ WHERE %@='%@'",kMoneyTable,value1,value2];
        }else{
            sql = [NSString stringWithFormat:
                   @"SELECT * FROM %@",kMoneyTable];
        }
        
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next]) {
            MoneyModel *model = [[MoneyModel alloc] init];
            model.name = [rs stringForColumn:@"name"];
            model.date = [rs stringForColumn:@"date"];
            model.type = [rs stringForColumn:@"type"];
            model.money = [rs stringForColumn:@"money"];
            model.Id = [rs stringForColumn:@"Id"];

            [array addObject:model];
        }
        //[db close];
    }
    return array;
}

#pragma mark - 朋友圈表
/**
 @{@"type":@"image",
 @"name":@"头条新闻",
 @"avatar":@"http://tp1.sinaimg.cn/1618051664/50/5735009977/0",
 @"content":@"#万象# 【熊孩子！4名小学生铁轨上设障碍物逼停火车】4名小学生打赌，1人认为火车会将石头碾成粉末，其余3人不信，认为只会碾碎，于是他们将道碴摆放在铁轨上。火车司机发现前方不远处的铁轨上，摆放了影响行车安全的障碍物，于是紧急采取制动，列车中途停车13分钟。O4名学生铁轨上设障碍物逼停火车#waynezxcv# nice",
 @"date":@"1459668442",
 @"imgs":@[@"http://ww2.sinaimg.cn/mw690/60718250jw1f2jg46smtmj20go0go77r.jpg"],
 @"statusID":@"4",
 @"commentList":@[@{@"from":@"waynezxcv",
 @"to":@"SIZE潮流生活",
 @"content":@"哈哈哈哈"},
 @{@"from":@"SIZE潮流生活",
 @"to":@"waynezxcv",
 @"content":@"nice~使用Gallop。支持异步绘制，让滚动如丝般顺滑。"}],
 @"isLike":@(NO),
 @"likeList":@[@"Tim Cook"]},
 */
- (void)createFriendsTable
{
    //sql 语句
    if ([db open]) {
        NSString *sqlCreateTable =  [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY AUTOINCREMENT, '%@' TEXT, '%@' TEXT, '%@' TEXT)",kFriendsTable,@"Id",@"userId",@"textContent",@"date"];
        BOOL res = [db executeUpdate:sqlCreateTable];
        if (!res) {
            NSLog(@"error when creating db table");
        } else {
            NSLog(@"success to creating db table");
        }
        //[db close];
        
    }
}

-(void)insertFriendsDataByUserId:(NSString *)userId
                        textContent:(NSString *)textContent
                       date:(NSString *)date
{
    if ([db open]) {
        NSString *insertSql1= [NSString stringWithFormat:
                               @"INSERT INTO '%@' ('%@', '%@','%@') VALUES ('%@', '%@','%@')",
                               kFriendsTable, @"userId", @"textContent", @"date", userId, textContent,date];
        BOOL res = [db executeUpdate:insertSql1];
        
        if (!res) {
            NSLog(@"error when insert db table");
        } else {
            NSLog(@"success to insert db table");
        }
        //[db close];
        
    }
    
}

-(NSMutableArray *)selectFriendsWhereValue1:(NSString *)value1 value2:(NSString *)value2 isNeed:(BOOL)isNeed
{
    NSMutableArray *array = [NSMutableArray array];
    if ([db open]) {
        NSString * sql ;
        if (isNeed) {
            sql = [NSString stringWithFormat:
                   @"SELECT * FROM %@ WHERE %@='%@'",kFriendsTable,value1,value2];
        }else{
            sql = [NSString stringWithFormat:
                   @"SELECT * FROM %@",kFriendsTable];
        }
        
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next]) {
            FriendsModel *model = [[FriendsModel alloc] init];
            model.Id = [rs stringForColumn:@"Id"];
            model.userId = [rs stringForColumn:@"userId"];
            model.textContent = [rs stringForColumn:@"textContent"];
            model.date = [rs stringForColumn:@"date"];
            
            [array addObject:model];
        }
        //[db close];
    }
    return array;
}

#pragma mark - 赞表
- (void)createZanTable
{
    //sql 语句
    if ([db open]) {
        NSString *sqlCreateTable =  [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY AUTOINCREMENT, '%@' TEXT, '%@' TEXT)",kZanTable,@"Id",@"friendsId",@"userId"];
        BOOL res = [db executeUpdate:sqlCreateTable];
        if (!res) {
            NSLog(@"error when creating db table");
        } else {
            NSLog(@"success to creating db table");
        }
        //[db close];
        
    }
}

-(void)insertZanDataByFriendsId:(NSString *)friendsId
                     userId:(NSString *)userId
{
    if ([db open]) {
        NSString *insertSql1= [NSString stringWithFormat:
                               @"INSERT INTO '%@' ('%@', '%@') VALUES ('%@', '%@')",
                               kZanTable, @"friendsId", @"userId", friendsId, userId];
        BOOL res = [db executeUpdate:insertSql1];
        
        if (!res) {
            NSLog(@"error when insert db table");
        } else {
            NSLog(@"success to insert db table");
        }
        //[db close];
        
    }
    
}

-(NSMutableArray *)selectZanWhereValue1:(NSString *)value1 value2:(NSString *)value2 isNeed:(BOOL)isNeed
{
    NSMutableArray *array = [NSMutableArray array];
    if ([db open]) {
        NSString * sql ;
        if (isNeed) {
            sql = [NSString stringWithFormat:
                   @"SELECT * FROM %@ WHERE %@='%@'",kZanTable,value1,value2];
        }else{
            sql = [NSString stringWithFormat:
                   @"SELECT * FROM %@",kZanTable];
        }
        
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next]) {
            ZanModel *model = [[ZanModel alloc] init];
            model.friendsId = [rs stringForColumn:@"friendsId"];
            model.userId = [rs stringForColumn:@"userId"];
            
            [array addObject:model];
        }
        //[db close];
    }
    return array;
}

-(NSMutableArray *)selectRandomZanWithNum:(NSString *)num
{
    NSMutableArray *array = [NSMutableArray array];
    if ([db open]) {
        NSString * sql ;

        sql = [NSString stringWithFormat:
                   @"select * from otherUserINFO order by RANDOM() limit %@",num];

        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next]) {
            UserInfoModel *model = [[UserInfoModel alloc] init];
            model.Id = [rs stringForColumn:ID];
            model.name = [rs stringForColumn:NAME];
            model.headImage = [rs stringForColumn:HEADIMAGE];
            model.wechatNum = [rs stringForColumn:WECHATNUM];
            model.money = [rs stringForColumn:MONEY];
            
            [array addObject:model];
        }
        //[db close];
    }
    return array;
}


/**
 @{@"type":@"image",
 @"name":@"头条新闻",
 @"avatar":@"http://tp1.sinaimg.cn/1618051664/50/5735009977/0",
 @"content":@"#万象# 【熊孩子！4名小学生铁轨上设障碍物逼停火车】4名小学生打赌，1人认为火车会将石头碾成粉末，其余3人不信，认为只会碾碎，于是他们将道碴摆放在铁轨上。火车司机发现前方不远处的铁轨上，摆放了影响行车安全的障碍物，于是紧急采取制动，列车中途停车13分钟。O4名学生铁轨上设障碍物逼停火车#waynezxcv# nice",
 @"date":@"1459668442",
 @"imgs":@[@"http://ww2.sinaimg.cn/mw690/60718250jw1f2jg46smtmj20go0go77r.jpg"],
 @"statusID":@"4",
 @"commentList":@[@{@"from":@"waynezxcv",
 @"to":@"SIZE潮流生活",
 @"content":@"哈哈哈哈"},
 @{@"from":@"SIZE潮流生活",
 @"to":@"waynezxcv",
 @"content":@"nice~使用Gallop。支持异步绘制，让滚动如丝般顺滑。"}],
 @"isLike":@(NO),
 @"likeList":@[@"Tim Cook"]},
 */
#pragma mark - 评论表
- (void)createCommentTable
{
    //sql 语句
    if ([db open]) {
        NSString *sqlCreateTable =  [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY AUTOINCREMENT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT)",kCommentTable,@"Id",@"friendsId",@"isFriends",@"fromUserId",@"toUserId",@"commentContent"];
        BOOL res = [db executeUpdate:sqlCreateTable];
        if (!res) {
            NSLog(@"error when creating db table");
        } else {
            NSLog(@"success to creating db table");
        }
        //[db close];
        
    }
}

-(void)insertCommentDataByFriendsId:(NSString *)friendsId
                     isFriends:(NSString *)isFriends
                    fromUserId:(NSString *)fromUserId
                            toUserId:(NSString *)toUserId
                        commentContent:(NSString *)commentContent
{
    if ([db open]) {
        NSString *insertSql1= [NSString stringWithFormat:
                               @"INSERT INTO '%@' ('%@', '%@','%@','%@','%@') VALUES ('%@', '%@', '%@','%@','%@')",
                               kCommentTable, @"friendsId", @"isFriends", @"fromUserId", @"toUserId" , @"commentContent", friendsId, isFriends, fromUserId,toUserId,commentContent];
        BOOL res = [db executeUpdate:insertSql1];
        
        if (!res) {
            NSLog(@"error when insert db table");
        } else {
            NSLog(@"success to insert db table");
        }
        //[db close];
        
    }
    
}

-(NSMutableArray *)selectCommentWhereValue1:(NSString *)value1 value2:(NSString *)value2 isNeed:(BOOL)isNeed
{
    NSMutableArray *array = [NSMutableArray array];
    if ([db open]) {
        NSString * sql ;
        if (isNeed) {
            sql = [NSString stringWithFormat:
                   @"SELECT * FROM %@ WHERE %@='%@'",kCommentTable,value1,value2];
        }else{
            sql = [NSString stringWithFormat:
                   @"SELECT * FROM %@",kCommentTable];
        }
        
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next]) {
            CommentModel2 *model = [[CommentModel2 alloc] init];
            model.friendsId = [rs stringForColumn:@"friendsId"];
            model.isFriends = [rs stringForColumn:@"isFriends"];
            model.fromUserId = [rs stringForColumn:@"fromUserId"];
            model.toUserId = [rs stringForColumn:@"toUserId"];
            model.commentContent = [rs stringForColumn:@"commentContent"];
            
            [array addObject:model];
        }
        //[db close];
    }
    return array;
}

#pragma mark - 朋友圈图片表

- (void)createImagesTable
{
    //sql 语句
    if ([db open]) {
        NSString *sqlCreateTable =  [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY AUTOINCREMENT, '%@' TEXT, '%@' blob)",kFriendsImagesTable,@"Id",@"friendsId",@"image"];
        BOOL res = [db executeUpdate:sqlCreateTable];
        if (!res) {
            NSLog(@"error when creating db table");
        } else {
            NSLog(@"success to creating db table");
        }
        //[db close];
        
    }
}

-(void)insertFriendsImagesDataByFriendsId:(NSString *)friendsId image:(NSString *)image
{
    if ([db open]) {
//        NSString *insertSql1= [NSString stringWithFormat:
//                               @"INSERT INTO '%@' ('%@', '%@','%@','%@','%@') VALUES ('%@', '%@', '%@','%@','%@')",
//                               kCommentTable, @"friendsId", @"isFriends", @"fromUserId", @"toUserId" , @"commentContent", friendsId, isFriends, fromUserId,toUserId,commentContent];
        BOOL flag = [db executeUpdate:@"insert into friendsImagesTable (friendsId,image) values(?,?)",friendsId,image];

//        BOOL res = [db executeUpdate:insertSql1];
        
        if (!flag) {
            NSLog(@"error when insert db table");
        } else {
            NSLog(@"success to insert db table");
        }
        //[db close];
        
    }
    
}

-(NSMutableArray *)selectFriendsImageWhereValue1:(NSString *)value1 value2:(NSString *)value2 isNeed:(BOOL)isNeed
{
    NSMutableArray *array = [NSMutableArray array];
    if ([db open]) {
        NSString * sql ;
        if (isNeed) {
            sql = [NSString stringWithFormat:
                   @"SELECT * FROM %@ WHERE %@='%@'",kFriendsImagesTable,value1,value2];
        }else{
            sql = [NSString stringWithFormat:
                   @"SELECT * FROM %@",kFriendsImagesTable];
        }
        
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next]) {
            NSString *imageUrl = [rs stringForColumn:@"image"];
            [array addObject:imageUrl];
        }
        //[db close];
    }
    return array;
}


#pragma mark - 银行卡表

- (void)createBankTable
{
    //sql 语句
    if ([db open]) {
        NSString *sqlCreateTable =  [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY AUTOINCREMENT, '%@' TEXT, '%@' TEXT)",kBankTable,@"Id",@"bankName",@"bankNum"];
        BOOL res = [db executeUpdate:sqlCreateTable];
        if (!res) {
            NSLog(@"error when creating db table");
        } else {
            NSLog(@"success to creating db table");
        }
        //[db close];
        
    }
}

-(void)insertBankDataByBankName:(NSString *)bankName
                        bankNum:(NSString *)bankNum
{
    if ([db open]) {
        NSString *insertSql1= [NSString stringWithFormat:
                               @"INSERT INTO '%@' ('%@', '%@') VALUES ('%@', '%@')",
                               kBankTable, @"bankName", @"bankNum", bankName, bankNum];
        BOOL res = [db executeUpdate:insertSql1];
        
        if (!res) {
            NSLog(@"error when insert db table");
        } else {
            NSLog(@"success to insert db table");
        }
        //[db close];
        
    }
    
}

-(NSMutableArray *)selectBankCardWhereValue1:(NSString *)value1 value2:(NSString *)value2 isNeed:(BOOL)isNeed
{
    NSMutableArray *array = [NSMutableArray array];
    if ([db open]) {
        NSString * sql ;
        if (isNeed) {
            sql = [NSString stringWithFormat:
                   @"SELECT * FROM %@ WHERE %@='%@'",kBankTable,value1,value2];
        }else{
            sql = [NSString stringWithFormat:
                   @"SELECT * FROM %@",kBankTable];
        }
        
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next]) {
            BankCardModel *model = [[BankCardModel alloc] init];
            model.bankName = [rs stringForColumn:@"bankName"];
            model.bankNum = [rs stringForColumn:@"bankNum"];
            model.Id = [rs stringForColumn:@"Id"];
            [array addObject:model];
        }
        //[db close];
    }
    return array;
}

#pragma mark - 聊天红包表

- (void)createRedPacketTable
{
    //sql 语句
    if ([db open]) {
        NSString *sqlCreateTable =  [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY AUTOINCREMENT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT,'%@'TEXT)",kRedPacketTable,@"Id",@"redMoney",@"redSurplusMoney",@"redNum",@"redSurplusNum",@"creatDate",@"endDate",@"redContent"];
        BOOL res = [db executeUpdate:sqlCreateTable];
        if (!res) {
            NSLog(@"error when creating db table");
        } else {
            NSLog(@"success to creating db table");
        }
        //[db close];
        
    }
}

-(void)insertRedPacketByRedMoney:(NSString *)redMoney
                        redSurplusMoney:(NSString *)redSurplusMoney
                         redNum:(NSString *)redNum
                  redSurplusNum:(NSString *)redSurplusNum
                      creatDate:(NSString *)creatDate
                        endDate:(NSString *)endDate
                     redContent:(NSString *)redContent
{
    if ([db open]) {
        NSString *insertSql1= [NSString stringWithFormat:
                               @"INSERT INTO '%@' ('%@', '%@', '%@', '%@', '%@', '%@', '%@') VALUES ('%@', '%@', '%@', '%@', '%@', '%@', '%@')",
                               kRedPacketTable, @"redMoney",@"redSurplusMoney",@"redNum",@"redSurplusNum",@"creatDate",@"endDate",@"redContent", redMoney, redSurplusMoney,redNum,redSurplusNum,creatDate,endDate,redContent];
        BOOL res = [db executeUpdate:insertSql1];
        
        if (!res) {
            NSLog(@"error when insert db table");
        } else {
            NSLog(@"success to insert db table");
        }
        //[db close];
        
    }
    
}

-(NSMutableArray *)selectRedPacketWhereValue1:(NSString *)value1 value2:(NSString *)value2 isNeed:(BOOL)isNeed
{
    NSMutableArray *array = [NSMutableArray array];
    if ([db open]) {
        NSString * sql ;
        if (isNeed) {
            sql = [NSString stringWithFormat:
                   @"SELECT * FROM %@ WHERE %@='%@'",kRedPacketTable,value1,value2];
        }else{
            sql = [NSString stringWithFormat:
                   @"SELECT * FROM %@",kRedPacketTable];
        }
        
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next]) {
            ChatRedPacketModel *model = [[ChatRedPacketModel alloc] init];
            model.Id = [rs stringForColumn:@"Id"];
            model.redMoney = [rs stringForColumn:@"redMoney"];
            model.redSurplusMoney = [rs stringForColumn:@"redSurplusMoney"];
            model.redNum = [rs stringForColumn:@"redNum"];
            model.redSurplusNum = [rs stringForColumn:@"redSurplusNum"];
            model.creatDate = [rs stringForColumn:@"creatDate"];
            model.endDate = [rs stringForColumn:@"endDate"];
            model.redContent = [rs stringForColumn:@"redContent"];
            [array addObject:model];
        }
        //[db close];
    }
    return array;
}

#pragma mark - 抢红包用户表

- (void)createGetRedPacketUserTable
{
    //sql 语句
    if ([db open]) {
        NSString *sqlCreateTable =  [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY AUTOINCREMENT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT)",kGetRedPacketUserTable,@"Id",@"userId",@"redId",@"getMoneyNum",@"getMoneyDate",@"isGreat"];
        BOOL res = [db executeUpdate:sqlCreateTable];
        if (!res) {
            NSLog(@"error when creating db table");
        } else {
            NSLog(@"success to creating db table");
        }
        //[db close];
        
    }
}

-(void)insertGetRedPacketUserByUserId:(NSString *)userId
                            redId:(NSString *)redId
                         getMoneyNum:(NSString *)getMoneyNum
                  getMoneyDate:(NSString *)getMoneyDate
                      isGreat:(NSString *)isGreat
{
    if ([db open]) {
        NSString *insertSql1= [NSString stringWithFormat:
                               @"INSERT INTO '%@' ('%@', '%@', '%@', '%@', '%@') VALUES ('%@', '%@', '%@', '%@', '%@')",
                               kGetRedPacketUserTable, @"userId",@"redId",@"getMoneyNum",@"getMoneyDate",@"isGreat", userId, redId,getMoneyNum,getMoneyDate,isGreat];
        BOOL res = [db executeUpdate:insertSql1];
        
        if (!res) {
            NSLog(@"error when insert db table");
        } else {
            NSLog(@"success to insert db table");
        }
        //[db close];
        
    }
    
}

-(NSMutableArray *)selectGetRedPacketUserWhereValue1:(NSString *)value1 value2:(NSString *)value2 isNeed:(BOOL)isNeed
{
    NSMutableArray *array = [NSMutableArray array];
    if ([db open]) {
        NSString * sql ;
        if (isNeed) {
            sql = [NSString stringWithFormat:
                   @"SELECT * FROM %@ WHERE %@='%@'",kGetRedPacketUserTable,value1,value2];
        }else{
            sql = [NSString stringWithFormat:
                   @"SELECT * FROM %@",kGetRedPacketUserTable];
        }
        
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next]) {
            GetRedUserModel *model = [[GetRedUserModel alloc] init];
            model.Id = [rs stringForColumn:@"Id"];
            model.userId = [rs stringForColumn:@"userId"];
            model.redId = [rs stringForColumn:@"redId"];
            model.getMoneyNum = [rs stringForColumn:@"getMoneyNum"];
            model.getMoneyDate = [rs stringForColumn:@"getMoneyDate"];
            model.isGreat = [rs stringForColumn:@"isGreat"];
            [array addObject:model];
        }
        //[db close];
    }
    return array;
}

#pragma mark - 微信支付表

- (void)createWechatPayUserTable
{
    //sql 语句
    if ([db open]) {
        NSString *sqlCreateTable =  [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY AUTOINCREMENT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT,'%@' TEXT)",kWechatPayTable,@"Id",@"type",@"money",@"startDate",@"endDate",@"remark",@"reason",@"userName"];
        BOOL res = [db executeUpdate:sqlCreateTable];
        if (!res) {
            NSLog(@"error when creating db table");
        } else {
            NSLog(@"success to creating db table");
        }
        //[db close];
        
    }
}

-(void)insertWechatPayUserByType:(NSString *)type
                                money:(NSString *)money
                          startDate:(NSString *)startDate
                         endDate:(NSString *)endDate
                            remark:(NSString *)remark
                              reason:(NSString *)reason
                        userName:(NSString *)userName
{
    if ([db open]) {
        NSString *insertSql1= [NSString stringWithFormat:
                               @"INSERT INTO '%@' ('%@', '%@', '%@', '%@', '%@', '%@','%@') VALUES ('%@','%@', '%@', '%@', '%@', '%@', '%@')",
                               kWechatPayTable, @"type",@"money",@"startDate",@"endDate",@"remark",@"reason",@"userName", type, money,startDate,endDate,remark,reason,userName];
        BOOL res = [db executeUpdate:insertSql1];
        
        if (!res) {
            NSLog(@"error when insert db table");
        } else {
            NSLog(@"success to insert db table");
        }
        //[db close];
        
    }
    
}

-(NSMutableArray *)selectWechatPayUserWhereValue1:(NSString *)value1 value2:(NSString *)value2 isNeed:(BOOL)isNeed
{
    NSMutableArray *array = [NSMutableArray array];
    if ([db open]) {
        NSString * sql ;
        if (isNeed) {
            sql = [NSString stringWithFormat:
                   @"SELECT * FROM %@ WHERE %@='%@'",kWechatPayTable,value1,value2];
        }else{
            sql = [NSString stringWithFormat:
                   @"SELECT * FROM %@",kWechatPayTable];
        }
        
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next]) {
            WechatPayModel *model = [[WechatPayModel alloc] init];
            model.Id = [rs stringForColumn:@"Id"];
            model.type = [rs stringForColumn:@"type"];
            model.money = [rs stringForColumn:@"money"];
            model.startDate = [rs stringForColumn:@"startDate"];
            model.endDate = [rs stringForColumn:@"endDate"];
            model.remark = [rs stringForColumn:@"remark"];
            model.reason = [rs stringForColumn:@"reason"];
            model.userName = [rs stringForColumn:@"userName"];
            [array addObject:model];
        }
        //[db close];
    }
    return array;
}

@end
