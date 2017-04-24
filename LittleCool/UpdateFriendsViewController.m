//
//  UpdateFriendsViewController.m
//  Qian
//
//  Created by 周博 on 17/2/28.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "UpdateFriendsViewController.h"
#import "ChooseAnyUsersViewController.h"
#import "BGDatePickerViewController.h"
#import "JTSTextView.h"

@interface UpdateFriendsViewController ()<JTSTextViewDelegate>
{
    
}
@property (nonatomic,strong) JTSTextView *textView;
@property (nonatomic,strong) UserInfoModel *user;
@end

@implementation UpdateFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navBarTitle:@"评论"];
    [self navBarbackButton:@"返回"];
    [self wechatRightButtonClick:@"完成"];
    [self getNoti];
    [self creatTextView];
}

//创建输入框
- (void)creatTextView{
    _textView = [[JTSTextView alloc] initWithFrame:CGRectMake(5, 5, kScreenSize.width - 10, _contentView.frame.size.height - 10) fontSize:17];
    [_contentView addSubview:_textView];
    _textView.tintColor = kWechatBlack;
    _textView.textViewDelegate = self;
    
    NSString *contentString ;
    if ([BGFunctionHelper isNULLOfString:_to]) {
        contentString = @"评论";
    }else{
        contentString = [NSString stringWithFormat:@"回复:%@",_to];
    }
    
    [self.textView setText:contentString];
}

//选择用户
- (IBAction)userButtonClick:(UIButton *)sender {
    UIStoryboard *storyboard = kWechatStroyboard;
    ChooseAnyUsersViewController *chooseAnyOneVC = [storyboard instantiateViewControllerWithIdentifier:@"ChooseAnyUsersViewController"];
    chooseAnyOneVC.chooseNum = @"1";
    chooseAnyOneVC.notiName = @"gengxinyonghu";
    [self.navigationController pushViewController:chooseAnyOneVC animated:YES];
}

//选择时间
- (IBAction)dateButtonClick:(UIButton *)sender {
    BGDatePickerViewController * picker = [[BGDatePickerViewController alloc] init];
    BGDatePickerAction * action = [BGDatePickerAction actionWithTitle:@"" handler:^(BGDatePickerAction *action) {
        _labelDate.text = action.titleS;
    }];
    [picker addAction:action];
    [self presentViewController:picker animated:NO completion:nil];
}

- (void)rightNavButtonClick{
//    if ([BGFunctionHelper isNULLOfString:_labelDate.text]) {
//        kAlert(@"请选择评论时间");
//        return;
//    }
    
    [[FMDBHelper fmManger] createCommentTable];
    [[FMDBHelper fmManger] insertCommentDataByFriendsId:_friendsId isFriends:@"" fromUserId:[BGFunctionHelper isNULLOfString:_user.name] ? _from : _user.name  toUserId:_to commentContent:_textView.text];
    
    [self.delegate changeFrom:[BGFunctionHelper isNULLOfString:_user.name] ? _from : _user.name content:_textView.text];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getNoti{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(choosePerson:) name:@"gengxinyonghu" object:nil];
}

#pragma mark - 点击事件
- (void)choosePerson:(NSNotification *)noti{
    _user = [noti.object lastObject];
    _labelUser.text = _user.name;
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
