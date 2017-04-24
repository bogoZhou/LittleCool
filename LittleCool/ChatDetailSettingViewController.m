//
//  ChatDetailSettingViewController.m
//  Qian
//
//  Created by 周博 on 17/2/24.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "ChatDetailSettingViewController.h"
#import "TakePicDelegate.h"

@interface ChatDetailSettingViewController ()
{
    
}
@property (nonatomic,strong) NSData *imageData;
@property (nonatomic,strong) NSString *isNoti;

@property (nonatomic,strong) ChatListModel *chatListModel;
@property (nonatomic,strong) UserInfoModel *userInfoModel;
@end

@implementation ChatDetailSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self creatUI];
    [self getNoti];
}

- (void)creatUI{
    [self navBarTitle:@"聊天详情"];
    [self navBarbackButton:@"返回"];
    [self wechatRightButtonClick:@"完成"];
    _chatListModel = [[[FMDBHelper fmManger] selectChatListWhereValue1:@"chatRoomId" value2:_chatRoomId isNeed:YES] lastObject];
    
    //设置开关状态
    _chatListModel.isNoti.integerValue > 0 ? [_mySwitch setOn:YES] : [_mySwitch setOn:NO];
    
    _userInfoModel = [[[FMDBHelper fmManger] selectUserInfoDataByValueName:@"Id" value:_userId] lastObject];
    
//    _imageViewHeader.image = [UIImage imageWithData:_userInfoModel.headImage];
    _imageViewHeader.image = [BGFunctionHelper getImageFromSandBoxByImagePath:_userInfoModel.headImage];
    _textFieldUserName.text = _userInfoModel.name;
}

- (void)getNoti{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeHeadImage:) name:@"otherUserHeaderImage" object:nil];
}

#pragma mark - 点击事件

//点击更换头像
- (IBAction)changeHeaderButtonClick:(UIButton *)sender {
    [[TakePicDelegate defaultManager] jumpAlarmInViewController:self notiName:@"otherUserHeaderImage"];
}

//选择是否设置免打扰
- (IBAction)swichChoose:(UISwitch *)sender {
    _mySwitch.isOn ? [_mySwitch setOn:NO] : [_mySwitch setOn:YES];
    _isNoti = _mySwitch.isOn ? @"1" : @"-1";
}

//清空聊天记录
- (IBAction)clearChatDetail:(UIButton *)sender {
   
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *clearAction = [UIAlertAction actionWithTitle:@"清空聊天记录" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
         [[FMDBHelper fmManger] deleteDataByTableName:kChatDetailTable TypeName:@"chatRoomId" TypeValue:_chatListModel.chatRoomId];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alert addAction:clearAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

//完成按钮
- (void)rightNavButtonClick{
    if ([BGFunctionHelper isNULLOfString:_textFieldUserName.text]) {
        kAlert(@"请输入昵称");
        return;
    }
    _imageData = UIImagePNGRepresentation(_imageViewHeader.image);
    
    [[FMDBHelper fmManger] updateDataByTableName:kOthreUserTable TypeName:@"headImage" typeValue0:_imageData typeValue1:@"Id" typeValue2:_userId];
    
    [[FMDBHelper fmManger] updateDataByTableName:kOthreUserTable TypeName:@"name" typeValue0:_textFieldUserName.text typeValue1:@"Id" typeValue2:_userId];
    
    [[FMDBHelper fmManger] updateDataByTableName:kChatListTable TypeName:@"isNoti" typeValue0:_isNoti typeValue1:@"chatRoomId" typeValue2:_chatListModel.chatRoomId];
    
    [[FMDBHelper fmManger] updateDataByTableName:kChatListTable TypeName:@"userName" typeValue0:_textFieldUserName.text typeValue1:@"chatRoomId" typeValue2:_chatListModel.chatRoomId];
    
    [self.navigationController popViewControllerAnimated:YES];
}

//选择改变头像图片
- (void)changeHeadImage:(NSNotification *)noti{
//    _imageViewHeader.image = [UIImage imageWithData:noti.object];
    _imageViewHeader.image = noti.object;
    [BGFunctionHelper saveImageToSandBoxByImage:noti.object];
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
