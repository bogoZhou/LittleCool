//
//  ChatDetailViewController.m
//  Qian
//
//  Created by 周博 on 17/2/10.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "ChatDetailViewController.h"
#import "ChatDetailTableViewCell.h"
#import "ChatDetailTableViewCell1.h"
#import "AllChatTableViewCell.h"
#import <AudioToolbox/AudioToolbox.h>
#import "RedPacketViewController.h"
#import "TakePicDelegate.h"
#import "BGDatePickerViewController.h"
#import "SliderViewController.h"
#import "SendMoneyViewController.h"
#import "ChatDetailSettingViewController.h"
#import "ChooseAnyUsersViewController.h"
#import "RedDetailViewController.h"

#define kCellMeChat @"ChatDetailTableViewCell1"
#define kCellYouChat @"ChatDetailTableViewCell"
#define kAllChatCell @"AllChatTableViewCell"
#define kAniTime 0.1

@interface ChatDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    NSString *_userType;
    BOOL _isClicklAddButton;
    NSString *_imageData;
    NSString *_myRedId;
}
@property (nonatomic,strong) UIButton *rightBTN;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) UserInfoModel *userModel;
@property (nonatomic,strong) UIView *keyboardView;
@property (nonatomic,strong) NSString *myChatRoomId;
@end

@implementation ChatDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    _dataArray = [NSMutableArray array];
    _userType = @"1";
    NSInteger allNum = 0;
    NSArray *array = [[FMDBHelper fmManger] selectChatListWhereValue1:@"" value2:@"" isNeed:NO];
    for (ChatListModel *listModel in array) {
        allNum += listModel.redNum.integerValue;
    }
    NSString *rightName = @"微信";
    NSString *rightName2 = [NSString stringWithFormat:@"%@(%ld)",@"微信",allNum];
    [self navBarbackButton:allNum > 0 ? rightName2 : rightName];
    [self navBarRButton];
    [self setUIFrame];
    [self creatKeyBoardHandle];
    [self registerCell];
    
    [self registerForKeyboardNotifications];
    [self creatGestureOnScrollView];
    [self showDataWithUserInfo:_userId];

     [[UIApplication sharedApplication] setApplicationSupportsShakeToEdit:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self tableViewDeep];
    if ([BGFunctionHelper isNULLOfString:_groupUsersId]) {
//        BGNotiView *notiView2 = [[BGNotiView alloc] initWithFrame:CGRectMake(38, kScreenSize.height - 49, 150, 50) contentText:@"摇一摇切换用户" direction:left];
        [[BGNotiView defaultManager] showNotiViewByFrame:CGRectMake(38, kScreenSize.height - 49 - 64, 150, 50) contentText:@"摇一摇切换用户" direction:left inVC:self];
    }else{
//        BGNotiView *notiView2 = [[BGNotiView alloc] initWithFrame:CGRectMake(38, kScreenSize.height - 49, 250, 50) contentText:@"点击切换角色,摇一摇切回自己" direction:left];
        [[BGNotiView defaultManager] showNotiViewByFrame:CGRectMake(38, kScreenSize.height - 49 - 64, 250, 50) contentText:@"点击切换角色,摇一摇切回自己" direction:left inVC:self];
    }
    
}

- (void)setUIFrame{
    _tableView.frame = CGRectMake(0, 0, kScreenSize.width, kScreenSize.height - 50);
    _viewInput.frame = CGRectMake(0, kScreenSize.height - 50, kScreenSize.width, 280);
    _viewHandle.frame = CGRectMake(0, 50, kScreenSize.width, 230);
    
    CGRect rect = _textFieldPut.frame;
    rect.size.height = 35;
    _textFieldPut.frame = rect;
    _textFieldPut.layer.masksToBounds = YES;
    _textFieldPut.layer.borderWidth = 0.5;
    _textFieldPut.layer.cornerRadius = 5;
    _textFieldPut.layer.borderColor = [kColorFrom0x(0xe3e3e5) CGColor];
}

- (void)registerCell{
    _isClicklAddButton = NO;
    _textFieldPut.delegate = self;
    _textFieldPut.returnKeyType = UIReturnKeySend;
    [_tableView registerClass:[AllChatTableViewCell class] forCellReuseIdentifier:kAllChatCell];
    
}

- (void)navBarRButton{
    _rightBTN = [UIButton buttonWithType:UIButtonTypeCustom];
    if (_groupUsersId) {
//        qunliao1.png
        [_rightBTN setFrame:CGRectMake(0, 0, 24, 16)];
        [_rightBTN setImage:[UIImage imageNamed:@"qunliao1.png"] forState:UIControlStateNormal];
    }else{
        [_rightBTN setFrame:CGRectMake(0, 0, 20, 18)];
        [_rightBTN setImage:[UIImage imageNamed:@"ren(1)"] forState:UIControlStateNormal];
        [_rightBTN addTarget:self action:@selector(rightButtonC) forControlEvents:UIControlEventTouchUpInside];
    }
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc] initWithCustomView:_rightBTN];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = 0;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, rightItem, nil];
    
}

#pragma mark - 创建小键盘功能键

- (void)creatKeyBoardHandle{
    CGFloat spaceWidth = (kScreenSize.width - 60 * 4) / 5;
    if (!_keyboardView) {
        _viewHandle.backgroundColor = kColorFrom0x(0xfbfbfb);
        NSArray *imageArray = @[@"zhaopian003.png",@"paishe003.png",@"hongbao003",@"zhuanzhang003.png",
                                @"fasongshijian003.png",@"fasongyuyin003.png",@"yuyinliaotian003.png",@"xiaoxichehui003.png"];
        NSArray *titleArray = @[@"照片",@"拍摄",@"红包",@"转账",
                                @"发送时间",@"发送语音",@"语音聊天",@"消息撤回"];
        for (int i = 0 ; i < 2; i ++) {
            for (int j = 0; j < 4 ; j ++) {
                _keyboardView = [[UIView alloc] initWithFrame:CGRectMake(spaceWidth + (spaceWidth + 60)*j, 10 +110 * i, 60, 85)];
                
                UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 5, 60, 60)];
                [button setBackgroundImage:[UIImage imageNamed:imageArray[j + 4* i]] forState:UIControlStateNormal];
                button.tag = 1000 + j + 4*i;
                [button addTarget:self action:@selector(handleViewButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, button.frame.origin.y + button.frame.size.height+ 5, 60, 15)];
                label.font = [UIFont systemFontOfSize:12];
                label.textAlignment = NSTextAlignmentCenter;
                label.userInteractionEnabled = YES;
                label.textColor = kColorFrom0x(0x888888);
                label.text = titleArray[j + 4*i];
                _keyboardView.backgroundColor = kColorFrom0x(0xfbfbfb);
                [_keyboardView addSubview:label];
                [_keyboardView addSubview:button];
                [_keyboardView bringSubviewToFront:button];
                [_viewHandle addSubview:_keyboardView];
                _viewInput.userInteractionEnabled = YES;
            }
        }
    }
}

#pragma mark - 点击事件
- (void)rightButtonC{
//    kAlert(@"添加好友");
    UIStoryboard *storyboard = kWechatStroyboard;
    ChatDetailSettingViewController * detail = [storyboard instantiateViewControllerWithIdentifier:@"ChatDetailSettingViewController"];
    
    detail.userId = _userModel.Id;
    detail.chatRoomId = _roomId;
    
    [self.navigationController pushViewController:detail animated:YES];
}

//语音按钮
- (IBAction)soundsButtonClick:(UIButton *)sender {
    if (_groupUsersId) {
        UIStoryboard *storyboard = kWechatStroyboard;
        ChooseAnyUsersViewController *chooseAnyUserVC = [storyboard instantiateViewControllerWithIdentifier:@"ChooseAnyUsersViewController"];
        chooseAnyUserVC.chooseNum = @"1";
        chooseAnyUserVC.notiName = @"huanren";
        [self.navigationController pushViewController:chooseAnyUserVC animated:YES];
    }else{
        SliderViewController *slider = [[SliderViewController alloc] init];
        BGSliderHelper *action = [BGSliderHelper actionWithTitle:@"" handler:^(BGSliderHelper *action) {
            NSLog(@"Slider -> %@",action.titleS);
            [self sendSoundsWithTime:action.titleS];
        }];
        [slider addAction:action];
        [self presentViewController:slider animated:NO completion:nil];
    }
    
}

//发送表情
- (IBAction)emojiButtonCLick:(UIButton *)sender {
//    kAlert(@"发送表情");
}

//小键盘加号
- (IBAction)addButtonClick:(UIButton *)sender {
//    if ([_textFieldPut isFirstResponder]) {
    [_textFieldPut resignFirstResponder];
//        _isClicklAddButton = YES;
//    }
    if (_viewInput.frame.origin.y == kScreenSize.height - 280 - 64) {
        [_textFieldPut becomeFirstResponder];
        _isClicklAddButton = YES;
    }else{
        [_textFieldPut resignFirstResponder];
        CGRect frame = _viewInput.frame;
        frame.origin.y = kScreenSize.height - 280 - 64;
        _viewInput.frame = frame;
        _tableView.frame = CGRectMake(_tableView.frame.origin.x, _tableView.frame.origin.y, _tableView.frame.size.width, _viewInput.frame.origin.y);
        [self tableViewDeep];
        _isClicklAddButton  = NO;
    }
}

- (void)handleViewButtonClick:(UIButton *)button{
    NSLog(@"%ld",button.tag);
    UIStoryboard *storyboard = kWechatStroyboard;

    if (button.tag == 1000) {//照片
        [[TakePicDelegate defaultManager] setMainController:self notiName:@"chatImage"];
        [[TakePicDelegate defaultManager] LocalPhoto];
    }else if (button.tag == 1001){//拍摄
        [[TakePicDelegate defaultManager] setMainController:self notiName:@"chatImage"];
        [[TakePicDelegate defaultManager] takePhoto];
    }else if (button.tag == 1002){//红包
        RedPacketViewController *redPacketVC = [storyboard instantiateViewControllerWithIdentifier:@"RedPacketViewController"];
        [redPacketVC navBarTitle:@"新增红包"];
        [redPacketVC navBarbackButton:@"返回"];
        [redPacketVC wechatRightButtonClick:@"完成"];
        [self.navigationController pushViewController:redPacketVC animated:YES];
    }else if (button.tag == 1003){//转账
        if (_groupUsersId) {
            kAlert(@"群组成员之间不能转账");
            return;
        }
        SendMoneyViewController *sendMoneyVC = [storyboard instantiateViewControllerWithIdentifier:@"SendMoneyViewController"];
        [self.navigationController pushViewController:sendMoneyVC animated:YES];
        
    }else if (button.tag == 1004){//发送时间
        BGDatePickerViewController *datePickerVC = [[BGDatePickerViewController alloc] init];
        BGDatePickerAction *action = [BGDatePickerAction actionWithTitle:@"" handler:^(BGDatePickerAction *action) {
            NSLog(@"date -> %@",action.titleS);
            NSString *dateString = [self countDate:action.titleS];
            [self cancelMessage:dateString type:@"111"];
        }];
        [datePickerVC addAction:action];
        [self presentViewController:datePickerVC animated:NO completion:nil];
    }else if (button.tag == 1005){//发送语音
        SliderViewController *slider = [[SliderViewController alloc] init];
        BGSliderHelper *action = [BGSliderHelper actionWithTitle:@"" handler:^(BGSliderHelper *action) {
            NSLog(@"Slider -> %@",action.titleS);
            [self sendSoundsWithTime:action.titleS];
        }];
        [slider addAction:action];
        [self presentViewController:slider animated:NO completion:nil];
    }else if (button.tag == 1006){//语音聊天
        kAlert(@"正在开发中...");
    }else{//消息撤回
        NSString *type;
        NSString *message;
        if (_userType.integerValue == 1) {//wo
            type = @"11";
            message = @"你撤回了一条消息";
        }else{
            type = @"12";
            message = [NSString stringWithFormat:@"\"%@\"撤回了一条消息",_userModel.name];
        }
        [self cancelMessage:message type:type];
    }
    
}

#pragma mark - handle方法
//发语音

- (void)sendSoundsWithTime:(NSString*)time{
    [[FMDBHelper fmManger] getFMDBBySQLName:kCreatSQL];
    [[FMDBHelper fmManger] creatChatListTable];
    [[FMDBHelper fmManger] creatChatDetailTable];
    
    NSMutableArray *array = [NSMutableArray array];
    if (_roomId) {
        //如果roomid存在 更新数据
        [[FMDBHelper fmManger] updateDataByTableName:kChatListTable TypeName:@"lastContent" typeValue0:@"[语音]" typeValue1:@"chatRoomId" typeValue2:_roomId];
        [[FMDBHelper fmManger] updateDataByTableName:kChatListTable TypeName:@"lastTime" typeValue0:[self countDate:[BGDateHelper seeDay][5]] typeValue1:@"chatRoomId" typeValue2:_roomId];
//        [[FMDBHelper fmManger] updateDataByTableName:kChatListTable TypeName:@"headImage" typeValue0:_userModel.headImage  typeValue1:@"chatRoomId" typeValue2:_roomId];
        
        NSMutableArray *aaaaa  =[[FMDBHelper fmManger] selectChatListWhereValue1:nil value2:nil isNeed:NO];
        NSLog(@"%@",aaaaa);
    }else{
        //如果不存在 添加数据
        [[FMDBHelper fmManger] insertChatListByTableName:kChatListTable lastTime:[self countDate:[BGDateHelper seeDay][5]] chatDetailId:@"1" isNoti:@"1" userImage:_userModel.headImage userName:_userModel.name lastContent:@"[语音]" userId:_userId];
        array = [[FMDBHelper fmManger] selectChatListWhereValue1:@"chatRoomId" value2:_roomId isNeed:NO];
        ChatListModel *model  = array.lastObject;
        _roomId = model.chatRoomId;
    }
    UserInfoModel *userModels = [[UserInfoModel alloc] init];
    NSString *userTYPE;
    if (_userType.integerValue == 1) {//我
        userTYPE = @"9";
        userModels = [[[FMDBHelper fmManger] selectDataByTableName:kOthreUserTable] firstObject];
    }else{
        userTYPE = @"10";
        userModels = _userModel;
    }
    
    [[FMDBHelper fmManger] insertChatDetailByTableName:kChatDetailTable chatRoomId:_roomId lastTime:[self countDate:[BGDateHelper seeDay][5]] userImage:userModels.headImage userName:userModels.name content:time type:userTYPE contentImage:_imageData];
    
    _dataArray = [[FMDBHelper fmManger] selectChatDetailWhereValue1:@"chatRoomId" value2:_roomId];
    
    [self.tableView reloadData];
    
    [self tableViewDeep];
}

//发送图片
- (void)changeImage:(NSNotification *)noti{
    _imageData = [BGFunctionHelper saveImageToSandBoxByImage:noti.object];
    
    [[FMDBHelper fmManger] getFMDBBySQLName:kCreatSQL];
    [[FMDBHelper fmManger] creatChatListTable];
    [[FMDBHelper fmManger] creatChatDetailTable];
    
    NSMutableArray *array = [NSMutableArray array];
    if (_roomId) {
        //如果roomid存在 更新数据
        [[FMDBHelper fmManger] updateDataByTableName:kChatListTable TypeName:@"lastContent" typeValue0:_textFieldPut.text typeValue1:@"chatRoomId" typeValue2:_roomId];
        [[FMDBHelper fmManger] updateDataByTableName:kChatListTable TypeName:@"lastTime" typeValue0:[self countDate:[BGDateHelper seeDay][5]]  typeValue1:@"chatRoomId" typeValue2:_roomId];
//        [[FMDBHelper fmManger] updateDataByTableName:kChatListTable TypeName:@"headImage" typeValue0:_userModel.headImage  typeValue1:@"chatRoomId" typeValue2:_roomId];
        
//        NSMutableArray *aaaaa  =[[FMDBHelper fmManger] selectChatListWhereValue1:nil value2:nil isNeed:NO];
//        NSLog(@"%@",aaaaa);
    }else{
        //如果不存在 添加数据
        [[FMDBHelper fmManger] insertChatListByTableName:kChatListTable lastTime:[self countDate:[BGDateHelper seeDay][5]] chatDetailId:@"1" isNoti:@"1" userImage:_userModel.headImage userName:_userModel.name lastContent:_textFieldPut.text userId:_userId];
        array = [[FMDBHelper fmManger] selectChatListWhereValue1:@"chatRoomId" value2:_roomId isNeed:NO];
        ChatListModel *model  = array.lastObject;
        _roomId = model.chatRoomId;
    }
    UserInfoModel *userModels = [[UserInfoModel alloc] init];
    NSString *userTYPE;
    if (_userType.integerValue == 1) {//我
        userTYPE = @"7";
        userModels = [[[FMDBHelper fmManger] selectDataByTableName:kOthreUserTable] firstObject];
    }else{
        userTYPE = @"8";
        userModels = _userModel;
    }
    
    [[FMDBHelper fmManger] insertChatDetailByTableName:kChatDetailTable chatRoomId:_roomId lastTime:[self countDate:[BGDateHelper seeDay][5]] userImage:userModels.headImage userName:userModels.name content:_textFieldPut.text type:userTYPE contentImage:_imageData];
    
    _dataArray = [[FMDBHelper fmManger] selectChatDetailWhereValue1:@"chatRoomId" value2:_roomId];
    
    [self.tableView reloadData];
    
    [self tableViewDeep];
}

//发红包
- (void)sendRedPacket:(NSNotification *)noti{
    NSString * redPacketId = noti.object;
    
    ChatRedPacketModel *redModel = [[[FMDBHelper fmManger] selectRedPacketWhereValue1:@"Id" value2:redPacketId isNeed:YES] lastObject];
    
    [[FMDBHelper fmManger] getFMDBBySQLName:kCreatSQL];
    [[FMDBHelper fmManger] creatChatListTable];
    [[FMDBHelper fmManger] creatChatDetailTable];
    
    NSMutableArray *array = [NSMutableArray array];
    if (_roomId) {
        //如果roomid存在 更新数据
        [[FMDBHelper fmManger] updateDataByTableName:kChatListTable TypeName:@"lastContent" typeValue0:[NSString stringWithFormat:@"[微信红包] %@",redModel.redContent] typeValue1:@"chatRoomId" typeValue2:_roomId];
        [[FMDBHelper fmManger] updateDataByTableName:kChatListTable TypeName:@"lastTime" typeValue0:[self countDate:[BGDateHelper seeDay][5]]  typeValue1:@"chatRoomId" typeValue2:_roomId];
        
        NSMutableArray *aaaaa  =[[FMDBHelper fmManger] selectChatListWhereValue1:nil value2:nil isNeed:NO];
        NSLog(@"%@",aaaaa);
    }else{
        //如果不存在 添加数据
        [[FMDBHelper fmManger] insertChatListByTableName:kChatListTable lastTime:[self countDate:[BGDateHelper seeDay][5]] chatDetailId:@"1" isNoti:@"1" userImage:_userModel.headImage userName:_userModel.name lastContent:[NSString stringWithFormat:@"[微信红包] %@",redModel.redContent] userId:_userId];
        array = [[FMDBHelper fmManger] selectChatListWhereValue1:@"chatRoomId" value2:_roomId isNeed:NO];
        ChatListModel *model  = array.lastObject;
        _roomId = model.chatRoomId;
    }
    UserInfoModel *userModels = [[UserInfoModel alloc] init];
    NSString *userTYPE;
    if (_userType.integerValue == 1) {//我
        userTYPE = @"5";
        userModels = [[[FMDBHelper fmManger] selectDataByTableName:kOthreUserTable] firstObject];
    }else{
        userTYPE = @"6";
        userModels = _userModel;
    }
    
    [[FMDBHelper fmManger] insertChatDetailByTableName:kChatDetailTable chatRoomId:_roomId lastTime:[self countDate:[BGDateHelper seeDay][5]] userImage:userModels.headImage userName:userModels.name content:redPacketId type:userTYPE contentImage:_imageData];
    
    _dataArray = [[FMDBHelper fmManger] selectChatDetailWhereValue1:@"chatRoomId" value2:_roomId];
    
    [self.tableView reloadData];
    
    [self tableViewDeep];
}

//转账
- (void)sendMoney:(NSNotification *)noti{
    NSDictionary *dict = (NSDictionary *)noti.object;
    
    NSString *money = dict[@"money"];
    NSString *conten = dict[@"content"];
    NSString *send = dict[@"send"];
    NSString *get = dict[@"get"];
    NSString *myType = dict[@"type"];
    
    UserInfoModel *user = [[UserInfoModel alloc] init];
    if (_userType.integerValue == 1) {//我
        user = _userModel;
    }else{
        user = [[[FMDBHelper fmManger] selectDataByTableName:kOthreUserTable] firstObject];
    }
    
    NSString *messages = [NSString stringWithFormat:@"%@$%@$%@$%@$%@",money,conten,send,get,user.name];
    
    [[FMDBHelper fmManger] getFMDBBySQLName:kCreatSQL];
    [[FMDBHelper fmManger] creatChatListTable];
    [[FMDBHelper fmManger] creatChatDetailTable];
    
    NSMutableArray *array = [NSMutableArray array];
    if (_roomId) {
        //如果roomid存在 更新数据
        [[FMDBHelper fmManger] updateDataByTableName:kChatListTable TypeName:@"lastContent" typeValue0:[NSString stringWithFormat:@"[微信转账]"] typeValue1:@"chatRoomId" typeValue2:_roomId];
        [[FMDBHelper fmManger] updateDataByTableName:kChatListTable TypeName:@"lastTime" typeValue0:[self countDate:[BGDateHelper seeDay][5]]  typeValue1:@"chatRoomId" typeValue2:_roomId];
//        [[FMDBHelper fmManger] updateDataByTableName:kChatListTable TypeName:@"headImage" typeValue0:_userModel.headImage  typeValue1:@"chatRoomId" typeValue2:_roomId];
        
        NSMutableArray *aaaaa  =[[FMDBHelper fmManger] selectChatListWhereValue1:nil value2:nil isNeed:NO];
        NSLog(@"%@",aaaaa);
    }else{
        //如果不存在 添加数据
        [[FMDBHelper fmManger] insertChatListByTableName:kChatListTable lastTime:[self countDate:[BGDateHelper seeDay][5]] chatDetailId:@"1" isNoti:@"1" userImage:_userModel.headImage userName:_userModel.name lastContent:[NSString stringWithFormat:@"[微信转账]"] userId:_userId];
        array = [[FMDBHelper fmManger] selectChatListWhereValue1:@"chatRoomId" value2:_roomId isNeed:NO];
        ChatListModel *model  = array.lastObject;
        _roomId = model.chatRoomId;
    }
    UserInfoModel *userModels = [[UserInfoModel alloc] init];
    NSString *userTYPE;
    
    if (_userType.integerValue == 1 && myType.integerValue == 0) {//我
        userTYPE = @"3";
        userModels = [[[FMDBHelper fmManger] selectDataByTableName:kOthreUserTable] firstObject];
    }else if (_userType.integerValue == 2 && myType.integerValue == 0){
        userTYPE = @"4";
        userModels = _userModel;
    }else if (myType.integerValue == 16){
        userTYPE = myType;
        userModels = _userModel;
    }else{
        userTYPE = myType;
        userModels = [[[FMDBHelper fmManger] selectDataByTableName:kOthreUserTable] firstObject];

    }
    
    [[FMDBHelper fmManger] insertChatDetailByTableName:kChatDetailTable chatRoomId:_roomId lastTime:[self countDate:[BGDateHelper seeDay][5]] userImage:userModels.headImage userName:userModels.name content:messages type:userTYPE contentImage:_imageData];
    
    _dataArray = [[FMDBHelper fmManger] selectChatDetailWhereValue1:@"chatRoomId" value2:_roomId];
    
    [self.tableView reloadData];
    
    [self tableViewDeep];
}

//消息撤回
- (void)cancelMessage:(NSString *)message type:(NSString *)type{

    [[FMDBHelper fmManger] getFMDBBySQLName:kCreatSQL];
    [[FMDBHelper fmManger] creatChatListTable];
    [[FMDBHelper fmManger] creatChatDetailTable];
    
    
    
    NSMutableArray *array = [NSMutableArray array];
    if (_roomId) {
        //如果roomid存在 更新数据
        if (type.integerValue == 13|| type.integerValue == 14) {
            NSArray *isRed = [message componentsSeparatedByString:@"      "];
            
            [[FMDBHelper fmManger] updateDataByTableName:kChatListTable TypeName:@"lastContent" typeValue0:[NSString stringWithFormat:@"%@",isRed[1]] typeValue1:@"chatRoomId" typeValue2:_roomId];
            [[FMDBHelper fmManger] updateDataByTableName:kChatListTable TypeName:@"lastTime" typeValue0:[self countDate:[BGDateHelper seeDay][5]]  typeValue1:@"chatRoomId" typeValue2:_roomId];
//            [[FMDBHelper fmManger] updateDataByTableName:kChatListTable TypeName:@"headImage" typeValue0:_userModel.headImage  typeValue1:@"chatRoomId" typeValue2:_roomId];
        }else if(type.integerValue == 111){
        }else{
            [[FMDBHelper fmManger] updateDataByTableName:kChatListTable TypeName:@"lastContent" typeValue0:message typeValue1:@"chatRoomId" typeValue2:_roomId];
            [[FMDBHelper fmManger] updateDataByTableName:kChatListTable TypeName:@"lastTime" typeValue0:[self countDate:[BGDateHelper seeDay][5]]  typeValue1:@"chatRoomId" typeValue2:_roomId];
//            [[FMDBHelper fmManger] updateDataByTableName:kChatListTable TypeName:@"headImage" typeValue0:_userModel.headImage  typeValue1:@"chatRoomId" typeValue2:_roomId];
        }

        NSMutableArray *aaaaa  =[[FMDBHelper fmManger] selectChatListWhereValue1:nil value2:nil isNeed:NO];
        NSLog(@"%@",aaaaa);
    }else{

        if (type.integerValue == 13 || type.integerValue == 14) {
            //如果不存在 添加数据
            [[FMDBHelper fmManger] insertChatListByTableName:kChatListTable lastTime:[self countDate:[BGDateHelper seeDay][5]] chatDetailId:@"1" isNoti:@"1" userImage:_userModel.headImage userName:_userModel.name lastContent:[NSString stringWithFormat:@"%@",message] userId:_userId];
        }else if (type.integerValue == 111){
            
        }else{
            //如果不存在 添加数据
            [[FMDBHelper fmManger] insertChatListByTableName:kChatListTable lastTime:[self countDate:[BGDateHelper seeDay][5]] chatDetailId:@"1" isNoti:@"1" userImage:_userModel.headImage userName:_userModel.name lastContent:message userId:_userId];
        }
        
        array = [[FMDBHelper fmManger] selectChatListWhereValue1:@"chatRoomId" value2:_roomId isNeed:NO];
        ChatListModel *model  = array.lastObject;
        _roomId = model.chatRoomId;
    }
    UserInfoModel *userModels = [[UserInfoModel alloc] init];
    NSString *userTYPE;
    if (type.integerValue == 111) {
        type = @"11";
    }
    if (_userType.integerValue == 1) {//我
        userTYPE = type;
        userModels = [[[FMDBHelper fmManger] selectDataByTableName:kOthreUserTable] firstObject];
    }else{
        userTYPE = type;
        userModels = _userModel;
    }
    
    [[FMDBHelper fmManger] insertChatDetailByTableName:kChatDetailTable chatRoomId:_roomId lastTime:[self countDate:[BGDateHelper seeDay][5]] userImage:userModels.headImage userName:userModels.name content:message type:userTYPE contentImage:_imageData];
    
    _dataArray = [[FMDBHelper fmManger] selectChatDetailWhereValue1:@"chatRoomId" value2:_roomId];
    
    [self.tableView reloadData];
    
    [self tableViewDeep];
}
#pragma mark - 填充数据

- (void)showDataWithUserInfo:(NSString *)userId{
    
    [[FMDBHelper fmManger] getFMDBBySQLName:kCreatSQL];
    [[FMDBHelper fmManger] creatChatListTable];
    
    if (_groupUsersId) {
        NSArray *groupIds = [_groupUsersId componentsSeparatedByString:@","];
        
        if (!_userModel) {
            _userModel = [[[FMDBHelper fmManger] selectUserInfoDataByValueName:@"Id" value:groupIds.firstObject] firstObject];
        }
    }else{
        _userModel = [[[FMDBHelper fmManger] selectUserInfoDataByValueName:@"Id" value:userId] firstObject];

    }
    
    
//    NSMutableArray * array = [[FMDBHelper fmManger] selectChatListWhereValue1:@"chatRoomId" value2:_roomId isNeed:YES];
    NSMutableArray *array = [[FMDBHelper fmManger] selectChatDetailWhereValue1:@"chatRoomId" value2:_roomId];

    _dataArray = array;
    [self.tableView reloadData];
    
}

#pragma mark - tableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChatModel *chatModel = _dataArray[indexPath.row];
    AllChatTableViewCell *cell = (AllChatTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kAllChatCell];
    if (!cell) {
        cell = [[AllChatTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kAllChatCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = kClearColor;
//    [[FMDBHelper fmManger] getFMDBBySQLName:kCreatSQL];
//    [[FMDBHelper fmManger] createTableByTableName:kUserTable];
//    UserInfoModel *model = [[UserInfoModel alloc] init];
//    model = [[[FMDBHelper fmManger] selectDataByTableName:kUserTable] lastObject];

    [cell showDataWithModel:chatModel];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    AllChatTableViewCell *cell = (AllChatTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.row == _dataArray.count -1) {
        return [cell height] + 12;
    }
    return [cell height];
}


#pragma mark - textFieldDelegate


- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [self tableViewDeep];
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
//    kAlert(@"点击了发送");
    
    if ([BGFunctionHelper isNULLOfString:theTextField.text]) {
        return YES;
    }
    
    [[FMDBHelper fmManger] getFMDBBySQLName:kCreatSQL];
    [[FMDBHelper fmManger] creatChatListTable];
    [[FMDBHelper fmManger] creatChatDetailTable];
    
    NSMutableArray *array = [NSMutableArray array];

    if (_roomId) {
        //如果roomid存在 更新数据
        [[FMDBHelper fmManger] updateDataByTableName:kChatListTable TypeName:@"lastContent" typeValue0:_textFieldPut.text typeValue1:@"chatRoomId" typeValue2:_roomId];
        [[FMDBHelper fmManger] updateDataByTableName:kChatListTable TypeName:@"lastTime" typeValue0:[self countDate:[BGDateHelper seeDay][5]]  typeValue1:@"chatRoomId" typeValue2:_roomId];
//        [[FMDBHelper fmManger] updateDataByTableName:kChatListTable TypeName:@"headImage" typeValue0:_userModel.headImage  typeValue1:@"chatRoomId" typeValue2:_roomId];
        
        NSMutableArray *aaaaa  =[[FMDBHelper fmManger] selectChatListWhereValue1:nil value2:nil isNeed:NO];
        NSLog(@"%@",aaaaa);
    }else{
        //如果不存在 添加数据
        [[FMDBHelper fmManger] insertChatListByTableName:kChatListTable lastTime:[self countDate:[BGDateHelper seeDay][5]] chatDetailId:@"1" isNoti:@"1" userImage:_userModel.headImage userName:_userModel.name lastContent:_textFieldPut.text userId:_userId];
        array = [[FMDBHelper fmManger] selectChatListWhereValue1:@"chatRoomId" value2:_roomId isNeed:NO];
        ChatListModel *model  = array.lastObject;
        _roomId = model.chatRoomId;
    }
    UserInfoModel *userModels = [[UserInfoModel alloc] init];
    if (_userType.integerValue == 1) {//我
         userModels = [[[FMDBHelper fmManger] selectDataByTableName:kOthreUserTable] firstObject];
    }else{
        userModels = _userModel;
    }

    [[FMDBHelper fmManger] insertChatDetailByTableName:kChatDetailTable chatRoomId:_roomId lastTime:[self countDate:[BGDateHelper seeDay][5]] userImage:userModels.headImage userName:userModels.name content:_textFieldPut.text type:_userType contentImage:_imageData];
    
    _dataArray = [[FMDBHelper fmManger] selectChatDetailWhereValue1:@"chatRoomId" value2:_roomId];
    
    
    [self.tableView reloadData];
    
    [self tableViewDeep];
    
    _textFieldPut.text = @"";
    
    return YES;
}

- (void)tableViewDeep{
    if (_dataArray.count > 0) {
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:_dataArray.count-1 inSection:0]
                                    animated:YES
                              scrollPosition:UITableViewScrollPositionBottom];
    }
}

#pragma mark - 注册通知

- (void) registerForKeyboardNotifications

{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(choosePerson:) name:@"huanren" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(whoChooseRed:) name:@"hongbaoxuanze" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteCells:) name:@"longPress" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendMoney:) name:@"clickZhuanZhang" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getRedPacket:) name:@"clickRedPacket" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeImage:) name:@"chatImage" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendRedPacket:) name:@"redPacket" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendMoney:) name:@"sendMoney" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardWillHideNotification object:nil];
}

//领取红包
- (void)whoChooseRed:(NSNotification *)noti{
    NSString *message;
    NSString *type;
    NSArray *userArray = noti.object;

    
    [[FMDBHelper fmManger] createGetRedPacketUserTable];
    BOOL isHaven;
    for (UserInfoModel *userModel in userArray) {
        isHaven = NO;
        ChatRedPacketModel *redModel = [[[FMDBHelper fmManger] selectRedPacketWhereValue1:@"Id" value2:_myRedId isNeed:YES] lastObject];
        NSArray *getRedUser = [[FMDBHelper fmManger] selectGetRedPacketUserWhereValue1:@"redId" value2:_myRedId isNeed:YES];
        
        
        NSString *countMoney = [self openRedPacketFunBySurplusNum:redModel.redSurplusNum surplusMoney:redModel.redSurplusMoney];
        
        NSString *money = [NSString stringWithFormat:@"%.2lf",redModel.redSurplusMoney.doubleValue - countMoney.doubleValue];
        
        NSString *surNum = [NSString stringWithFormat:@"%ld",redModel.redSurplusNum.integerValue - 1];
        
        for (GetRedUserModel *newGet in getRedUser) {
            if ([newGet.userId isEqualToString:userModel.Id]) {
                isHaven = YES;
                break;
            }
        }
        //判断领取红包的用户是否存在
        if (!isHaven) {//如果不存在则存储更新
            [[FMDBHelper fmManger] updateDataByTableName:kRedPacketTable TypeName:@"redSurplusNum" typeValue0:surNum typeValue1:@"Id" typeValue2:_myRedId];
            [[FMDBHelper fmManger] updateDataByTableName:kRedPacketTable TypeName:@"redSurplusMoney" typeValue0:money typeValue1:@"Id" typeValue2:_myRedId];
            
            
            [[FMDBHelper fmManger] insertGetRedPacketUserByUserId:userModel.Id redId:_myRedId getMoneyNum:countMoney getMoneyDate:[self countDate:[BGDateHelper seeDay][5]] isGreat:@"0"];
            
            //判断是否是最后一个红包
            if (redModel.redSurplusNum.integerValue == 1) {
                if ([userModel.Id isEqualToString:@"1"]) {
                    message = [NSString stringWithFormat:@"      你领取了自己发的红包，你的红包已被领完"];
                }else{
                    message = [NSString stringWithFormat:@"      %@领取了你的红包，你的红包已被领完",userModel.name];
                }
            }else{
                if ([userModel.Id isEqualToString:@"1"]) {
                    message = [NSString stringWithFormat:@"      你领取了自己发的红包"];
                }else{
                    message = [NSString stringWithFormat:@"      %@领取了你的红包",userModel.name];
                }
            }
            type = @"14";
            [self cancelMessage:message type:type];
        }
    }
    //判断手气最佳
    ChatRedPacketModel *redModel = [[[FMDBHelper fmManger] selectRedPacketWhereValue1:@"Id" value2:_myRedId isNeed:YES] lastObject];
    if (userArray.count == redModel.redNum.integerValue) {
        NSArray *getRedUser = [[FMDBHelper fmManger] selectGetRedPacketUserWhereValue1:@"redId" value2:_myRedId isNeed:YES];
        GetRedUserModel *userModel = getRedUser.firstObject;
        for (GetRedUserModel *mod in getRedUser) {
            if (userModel.getMoneyNum.doubleValue < mod.getMoneyNum.doubleValue) {
                userModel = mod;
            }
        }
        [[FMDBHelper fmManger] updateDataByTableName:kGetRedPacketUserTable TypeName:@"isGreat" typeValue0:@"1" typeValue1:@"Id" typeValue2:userModel.Id];
    }
}

- (NSString *)openRedPacketFunBySurplusNum:(NSString *)surplusNum surplusMoney:(NSString *)surplusMoney{
    NSString *moneyStr = [NSString stringWithFormat:@"%.2lf",surplusMoney.doubleValue];
    if (surplusNum.integerValue > 1) {
        //百分比
        CGFloat randomPersent = (arc4random()%100)/100.0;
        
        //最小值
        CGFloat min = 0.01;
        //最大值,平均数的两倍
        CGFloat max = surplusMoney.floatValue/surplusNum.floatValue*2;
        
        CGFloat money = max * randomPersent;
        
        money = money < 0.01 ? min : money;
        
        moneyStr = [NSString stringWithFormat:@"%.2lf",money];
        
    }
    return moneyStr;
}

- (void)choosePerson:(NSNotification *)noti{
    
    _userModel = [noti.object lastObject];
    
    _userType = @"2";
    [_buttonSound setImage:[BGFunctionHelper getImageFromSandBoxByImagePath:_userModel.headImage] forState:UIControlStateNormal];
}

- (void)getRedPacket:(NSNotification *)noti{
    NSDictionary *dict = noti.object;
    NSString *type = dict[@"type"];
    _myRedId = dict[@"redId"];
    [[FMDBHelper fmManger] getFMDBBySQLName:kCreatSQL];
    [[FMDBHelper fmManger] createTableByTableName:kOthreUserTable];
    UserInfoModel *model = [[UserInfoModel alloc] init];
    model = [[[FMDBHelper fmManger] selectDataByTableName:kOthreUserTable] firstObject];
    ChatRedPacketModel *chatRedModel = [[[FMDBHelper fmManger] selectRedPacketWhereValue1:@"Id" value2:_myRedId isNeed:YES] lastObject];
    NSString *message;
    if (type.integerValue == 5) {//我发的红包
        UIStoryboard *storyboard = kWechatStroyboard;

        if (_groupUsersId) {
            if (chatRedModel.redSurplusNum.integerValue == 0) {
//                kAlert(@"红包已领完");
                //从这里跳入红包详情页面;
                RedDetailViewController *redDetail = [storyboard instantiateViewControllerWithIdentifier:@"RedDetailViewController"];
                redDetail.redId = _myRedId;
                [self.navigationController pushViewController:redDetail animated:YES];
                
            }else{
                ChooseAnyUsersViewController *chooseAnyVC = [storyboard instantiateViewControllerWithIdentifier:@"ChooseAnyUsersViewController"];
                //            NSArray *array = [_groupUsersId componentsSeparatedByString:@","];
                
                chooseAnyVC.redPacketId = _myRedId;
                chooseAnyVC.userIds = _groupUsersId;
                chooseAnyVC.chooseNum = [NSString stringWithFormat:@"%@",chatRedModel.redNum];
                chooseAnyVC.notiName = @"hongbaoxuanze";
                [self.navigationController pushViewController:chooseAnyVC animated:YES];
            }
        }else{
            message = [NSString stringWithFormat:@"      %@领取了你的红包",_userModel.name];
            type = @"14";
            [self cancelMessage:message type:type];
        }
        
    }else if (type.integerValue == 6){//对方发的红包
        message = [NSString stringWithFormat:@"      你领取了%@的红包",_userModel.name];
        type = @"13";
        [self cancelMessage:message type:type];
    }
}

- (void)deleteCells:(NSNotification *)noti{
    NSString *chatDetailId = noti.object;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [[FMDBHelper fmManger] deleteDataByTableName:kChatDetailTable TypeName:@"chatDetailId" TypeValue:chatDetailId];
        
        _dataArray = [[FMDBHelper fmManger] selectChatDetailWhereValue1:@"chatRoomId" value2:_roomId];
        
        [self.tableView reloadData];
    }];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alert addAction:deleteAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 动态计算键盘高度

- (void) keyboardWasShown:(NSNotification *) notif

{
    NSDictionary *info = [notif userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    [UIView animateWithDuration:kAniTime animations:^{
        CGRect frame = _viewInput.frame;
        frame.origin.y = kScreenSize.height - keyboardSize.height - 64 - 49;
        _viewInput.frame = frame;
        _tableView.frame = CGRectMake(_tableView.frame.origin.x, _tableView.frame.origin.y, _tableView.frame.size.width, _viewInput.frame.origin.y);
        [self tableViewDeep];
    }];
}

- (void) keyboardWasHidden:(NSNotification *) notif

{
    [UIView animateWithDuration:kAniTime animations:^{
        CGRect frame = _viewInput.frame;
        frame.origin.y = kScreenSize.height - 50 - 64;
        _viewInput.frame = frame;
        _tableView.frame = CGRectMake(_tableView.frame.origin.x, _tableView.frame.origin.y, _tableView.frame.size.width, _viewInput.frame.origin.y);
        [self tableViewDeep];
    }];
}


#pragma mark - 摇一摇切换用户
- (void) motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    NSLog(@"开始摇动");
}

- (void) motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    NSLog(@"取消摇动");
    
}

- (void) motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    NSLog(@"结束摇动");
    if (event.subtype == UIEventSubtypeMotionShake) {
        //something happens
        NSLog(@"这里是摇动事件");
        if (_userType.integerValue == 1) {
            _userType = @"2";
            if (_groupUsersId) {
//                UIStoryboard *storyboard = kWechatStroyboard;
//                ChooseAnyUsersViewController *chooseAnyUserVC = [storyboard instantiateViewControllerWithIdentifier:@"ChooseAnyUsersViewController"];
//                chooseAnyUserVC.chooseNum = @"1";
//                [self.navigationController pushViewController:chooseAnyUserVC animated:YES];
                
                NSArray *groupIds = [_groupUsersId componentsSeparatedByString:@","];
                
                if (!_userModel) {
                    _userModel = [[[FMDBHelper fmManger] selectUserInfoDataByValueName:@"Id" value:groupIds.firstObject] firstObject];
                }
//                [_buttonSound setImage:[UIImage imageWithData:_userModel.headImage] forState:UIControlStateNormal];
                [_buttonSound setImage:[BGFunctionHelper getImageFromSandBoxByImagePath:_userModel.headImage] forState:UIControlStateNormal];

            }
            
            

            kAlert(@"我已经不是我了!");
        }else{
            _userType = @"1";
            kAlert(@"我还是我!");
            [_buttonSound setImage:[UIImage imageNamed:@"VoiceYuyin.png"] forState:UIControlStateNormal];
        }
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
}

- (void)creatGestureOnScrollView{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewHiddenKeyboard)];
    tapGesture.numberOfTouchesRequired = 1;
    [_tableView addGestureRecognizer:tapGesture];
}

- (void)scrollViewHiddenKeyboard{
    [self keyboardWasHidden:nil];
    [self.textFieldPut resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
