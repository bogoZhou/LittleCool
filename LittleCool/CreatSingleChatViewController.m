//
//  CreatSingleChatViewController.m
//  Qian
//
//  Created by 周博 on 17/3/2.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "CreatSingleChatViewController.h"
#import "TakePicDelegate.h"

#define kSingleImage @"singleImage"

@interface CreatSingleChatViewController ()
{
    
}
@property (nonatomic,strong) NSString *loadUserImage;
@property (nonatomic,strong) NSString *loadUserName;
@end

@implementation CreatSingleChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navBarTitle:@"创建单聊"];
    [self navBarbackButton:@"返回"];
    [self wechatRightButtonClick:@"完成"];
    [self creatGestureOnScrollView:_backScroll];
    [self defaultUser];
    _switchButton.on = YES;
    [self switchClick:_switchButton];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getHeaderImage:) name:kSingleImage object:nil];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    _layoutWidth.constant = kScreenSize.width;
    _layoutHeight.constant = _viewDeep.frame.origin.y + _viewDeep.frame.size.height;
}

//创建时的默认数据

- (void)defaultUser{
    _textFieldDate.text = [BGDateHelper seeDay][5];
//    [[AFClient shareInstance] getUserRandomByCount:@"1" progressBlock:^(NSProgress *progress) {
//        
//    } success:^(id responseBody) {
//        if ([responseBody[@"code"] integerValue] == 200) {
//            for (NSDictionary *dic in responseBody[@"data"]) {
//                _loadUserImage = dic[@"img_url"];
//                _loadUserName = dic[@"name"];
//            }
//            [self setUsers];
//        }
//    } failure:^(NSError *error) {
//        
//    }];
    
}

- (void)setUsers{
    [_imageViewHeader sd_setImageWithURL:[NSURL URLWithString:_loadUserImage]];
    _textFieldNickName.text = _loadUserName;
}

#pragma mark - 点击事件
//点击选择头像
- (IBAction)chooseHeaderButtonClick:(UIButton *)sender {
    [[TakePicDelegate defaultManager] setMainController:self notiName:kSingleImage];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"编辑头像" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[TakePicDelegate defaultManager] takePhoto];
    }];
    
    UIAlertAction *locationPic = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[TakePicDelegate defaultManager] LocalPhoto];
    }];
    
    UIAlertAction *autoGet = [UIAlertAction actionWithTitle:@"自动获取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self defaultUser];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alert addAction:takePhotoAction];
    [alert addAction:locationPic];
    [alert addAction:autoGet];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

//消息发送时间
- (IBAction)chooseDateButtonClick:(UIButton *)sender {
    
}


//点击完成
- (void)rightNavButtonClick{
    if ( [BGFunctionHelper isNULLOfString:_textFieldNickName.text]) {
        kAlert(@"请先写昵称");
        return;
    }
    
    //如果昵称和头像都存在，则 先添加到user表中 再创建聊天list表
    [[FMDBHelper fmManger] creatChatListTable];
    //创建user
    [[FMDBHelper fmManger] insertOtherUserInfoDataByTableName:kOthreUserTable Id:@"1" name:_textFieldNickName.text headImage:UIImagePNGRepresentation(_imageViewHeader.image) wechatNum:@"singleDog" money:@"666"];
    
    UserInfoModel *model = [[[FMDBHelper fmManger] selectDataByTableName:kOthreUserTable] lastObject];
    
    //创建chatList
    [[FMDBHelper fmManger] insertChatListByTableName:kChatListTable lastTime:[self countDate:_textFieldDate.text] chatDetailId:@"1" isNoti:@"1" userImage:UIImagePNGRepresentation(_imageViewHeader.image) userName:_textFieldNickName.text lastContent:_switchButton.isOn ? [NSString stringWithFormat:@"我是%@",_textFieldNickName.text] : @" "  userId:model.Id];
    
    if (_switchButton.isOn) {//如果是新好友
        NSString *message1 = _textFieldContent1.text;
        NSString *message2 = _textFieldContent2.text;
        NSString *message3 = _textFieldContent3.text;
        if ([BGFunctionHelper isNULLOfString:_textFieldContent1.text]) {
            message1 = @"以上是打招呼的内容";
        }
        if ([BGFunctionHelper isNULLOfString:_textFieldContent2.text]) {
            message2 = [NSString stringWithFormat:@"你已添加了%@，现在可以开始聊天了。",_textFieldNickName.text];
        }
        if ([BGFunctionHelper isNULLOfString:_textFieldContent3.text]) {
            message3 = @"如果陌生人主动添加你为好友，请谨慎核实对方身份。";
        }
        
        ChatListModel *chatListModel = [[[FMDBHelper fmManger] selectChatListWhereValue1:nil value2:nil isNeed:NO] lastObject];
        //创建聊天详情表
        [[FMDBHelper fmManger] creatChatDetailTable];
        
        //date
        [[FMDBHelper fmManger] insertChatDetailByTableName:kChatDetailTable chatRoomId:chatListModel.chatRoomId lastTime:[self countDate:_textFieldDate.text]  userImage:chatListModel.userImage userName:chatListModel.userName content:[self countDate:_textFieldDate.text]  type:@"11" contentImage:nil];
        
        //打招呼内容
        [[FMDBHelper fmManger] insertChatDetailByTableName:kChatDetailTable chatRoomId:chatListModel.chatRoomId lastTime:[self countDate:_textFieldDate.text]  userImage:chatListModel.userImage userName:chatListModel.userName content:[NSString stringWithFormat:@"我是%@",_textFieldNickName.text] type:@"2" contentImage:nil];
        
        //message1
        [[FMDBHelper fmManger] insertChatDetailByTableName:kChatDetailTable chatRoomId:chatListModel.chatRoomId lastTime:[self countDate:_textFieldDate.text]  userImage:chatListModel.userImage userName:chatListModel.userName content:message1 type:@"17" contentImage:nil];
        
        //message2
        [[FMDBHelper fmManger] insertChatDetailByTableName:kChatDetailTable chatRoomId:chatListModel.chatRoomId lastTime:[self countDate:_textFieldDate.text]  userImage:chatListModel.userImage userName:chatListModel.userName content:message2 type:@"18" contentImage:nil];
        
        //message3
        [[FMDBHelper fmManger] insertChatDetailByTableName:kChatDetailTable chatRoomId:chatListModel.chatRoomId lastTime:[self countDate:_textFieldDate.text]  userImage:chatListModel.userImage userName:chatListModel.userName content:message3 type:@"19" contentImage:nil];
    }
    
    
    //返回到聊天一级页面
    [self.navigationController popToViewController:self.navigationController.viewControllers.firstObject animated:YES];
}

// 选择 是否是新好友
- (IBAction)switchClick:(UISwitch *)sender {
    if (sender.isOn) {//如果打开 line为 half
        _imageViewHalf.hidden = NO;
        _imageviewAll.hidden = YES;
        [UIView animateWithDuration:0.1 animations:^{
            _viewDeep.alpha = 1;
        }];
    }else{
        _imageViewHalf.hidden = YES;
        _imageviewAll.hidden = NO;
        [UIView animateWithDuration:0.1 animations:^{
            _viewDeep.alpha = 0;
        }];
    }
}

#pragma mark - 接收通知

- (void)getHeaderImage:(NSNotification *)noti{
    _imageViewHeader.image = [UIImage imageWithData:noti.object];
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
