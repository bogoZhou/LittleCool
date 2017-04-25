//
//  UserAccountViewController.m
//  noteMan
//
//  Created by 周博 on 16/12/15.
//  Copyright © 2016年 BogoZhou. All rights reserved.
//

#import "UserAccountViewController.h"
#import "WithDrawViewController.h"

static NSString *kAuthScope = @"snsapi_message,snsapi_userinfo";
static NSString *kAuthOpenID = @"5ae9f5767bef4a3ff9245b3a7f4aa054";
static NSString *kAuthState = @"wxb1e4458be71faee9";

@interface UserAccountViewController ()<WXApiDelegate>
@property (nonatomic,strong) MBProgressHUD *hud;

@end

@implementation UserAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navBarTitle:@"账户余额"];
    [self navBarbackButton:@"        "];
    
    _labelMoney.text = _moneyStr;
    
    CGSize titleSize = [_labelMoney.text boundingRectWithSize:CGSizeMake(kScreenSize.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_labelMoney.font} context:nil].size;
    
    _labelMoney.frame = CGRectMake(_labelMoney.orginX, _labelMoney.orginY, titleSize.width, _labelMoney.sizeHeight);
    
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
    
        [_hud showAnimated:YES];
    NSDictionary *dic = (NSDictionary *)noti.object;
    
    NSString * headImgUrl = [dic objectForKey:@"headimgurl"]; // 传递头像地址
    NSString * nickname = [dic objectForKey:@"nickname"]; // 传递昵称
    NSString * openid = [dic objectForKey:@"openid"];
    NSString * unionId = [dic objectForKey:@"unionid"];
    
//    NSLog(@"%@,%@,%@,%@",headImgUrl,nickname,openid,unionId);
    
    [[AFClient shareInstance] relationWechatByUserId:kUserId open_id:openid unionid:unionId progressBlock:^(NSProgress *progress) {
        
    } success:^(id responseBody) {
        if ([responseBody[@"code"] integerValue] == 200) {
            [self loginFunc];
        }else{
            kAlert(responseBody[@"message"]);
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)note1{
    [_hud hideAnimated:YES];
}


#pragma mark - 点击事件

- (IBAction)backButtonClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)withDrawButtonClick:(UIButton *)sender {
    [[AFClient shareInstance] isRelationWechatByUserId:kUserId progressBlock:^(NSProgress *progress) {
        
    } success:^(id responseBody) {
        if ([responseBody[@"code"] integerValue] == 200) {
            [self loginFunc];
        }else{
            [self creatAlert];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)creatAlert{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"使用微信授权号登录" message:@"1.关注微信公众号:全民纸条客\n2.使用关注的微信号授权登录" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        SendAuthReq *req =[[SendAuthReq alloc ] init];
        req.scope = kAuthScope; // 此处不能随意改
        req.state = kAuthState; // 这个貌似没影响
        
        BOOL str = [WXApi isWXAppInstalled];
        if (str) {
            [WXApi sendReq:req];
        }else{
            [WXApi sendAuthReq:req viewController:self delegate:self];
        }
    }];
    [alert addAction:cancelAction];
    [alert addAction:sureAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)loginFunc{
    UIStoryboard *storyboard = kMainStroyboard;
    WithDrawViewController *withDrawVC = [storyboard instantiateViewControllerWithIdentifier:@"WithDrawViewController"];
    withDrawVC.withDrawMoney = _withDrowMoneyStr;
    [self.navigationController pushViewController:withDrawVC animated:YES];
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
