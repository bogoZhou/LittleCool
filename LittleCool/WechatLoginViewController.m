//
//  WechatLoginViewController.m
//  LittleCool
//
//  Created by 周博 on 17/3/19.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "WechatLoginViewController.h"

static NSString *kAuthScope = @"snsapi_message,snsapi_userinfo";
static NSString *kAuthOpenID = @"5ae9f5767bef4a3ff9245b3a7f4aa054";
static NSString *kAuthState = @"wxb1e4458be71faee9";

@interface WechatLoginViewController ()<WXApiDelegate>
@property (nonatomic,strong) MBProgressHUD *hud;

@end

@implementation WechatLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(note:)
                                                 name:@"Note"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(note1)
                                                 name:@"Note1"
                                               object:nil];
    NSData * data1 = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"];
    if (data1.length > 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"login" object:nil];
    }
    
}

/**
 *  微信回调，跳转完善资料页面
 */
- (void)note:(NSNotification *)noti{
    
    //    [self showGif];
    //    [_hud showAnimated:YES];
    NSDictionary *dic = (NSDictionary *)noti.object;
    
    NSString * headImgUrl = [dic objectForKey:@"headimgurl"]; // 传递头像地址
    NSString * nickname = [dic objectForKey:@"nickname"]; // 传递昵称
    NSString * openid = [dic objectForKey:@"openid"];
    NSString * unionId = [dic objectForKey:@"unionid"];
    
    NSLog(@"%@,%@,%@,%@",headImgUrl,nickname,openid,unionId);
    
//    [self loadDataByNickName:nickname
//                     headUrl:headImgUrl
//                      openId:openid
//                     unionId:unionId];
//    
}

- (void)note1{
        [_hud hideAnimated:YES];
}

#pragma mark - 点击事件

- (IBAction)loginButtonClick:(UIButton *)sender {
    
    SendAuthReq *req =[[SendAuthReq alloc ] init];
    req.scope = kAuthScope; // 此处不能随意改
    req.state = kAuthState; // 这个貌似没影响
    
    
    BOOL str = [WXApi isWXAppInstalled];
//    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    [_hud showAnimated:YES];
    if (!str) {
        [WXApi sendReq:req];
    }else{
        [WXApi sendAuthReq:req viewController:self delegate:self];
    }
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
