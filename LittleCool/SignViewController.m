//
//  SignViewController.m
//  LittleCool
//
//  Created by 周博 on 17/3/13.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "SignViewController.h"

@interface SignViewController ()
{
    
}
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic) double timeCount;
@property (nonatomic,strong) MBProgressHUD *hud;
@end

@implementation SignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self fristStept];
//    [self textAfClient];
}

- (void)fristStept{
    [self lockedGetCodeButton:_getCodeButton];
    
    [_textFieldMobile addTarget:self action:@selector(mobileTextFieldEditing) forControlEvents:UIControlEventEditingChanged];
    
    [_textFieldCode addTarget:self action:@selector(codeTextFieldEditing) forControlEvents:UIControlEventEditingChanged];
}

- (void)lockedGetCodeButton:(UIButton *)button{
    button.enabled = NO;
    [button setTintColor:kColorFrom0x(0x9ca0a4)];
}

- (void)unlockedGetCodeButton:(UIButton *)button{
    button.enabled = YES;
    [button setTintColor:kColorFrom0x(0x2596ff)];
}

#pragma mark - textField方法

- (void)mobileTextFieldEditing{
    if ([BGFunctionHelper checkTel:_textFieldMobile.text]) {
        [self unlockedGetCodeButton:_getCodeButton];
    }else{
        [self lockedGetCodeButton:_getCodeButton];
    }
}

- (void)codeTextFieldEditing{
    if ([BGFunctionHelper checkNum:_textFieldCode.text]) {
        if (_textFieldCode.text.length == 4) {
            [self unlockedGetCodeButton:_loginButton];
        }else{
            [self lockedGetCodeButton:_loginButton];
        }
    }else{
        [self lockedGetCodeButton:_loginButton];
    }
}

#pragma mark - 点击事件
//点击获取验证码
- (IBAction)getCodeButtonClick:(UIButton *)sender {
    [self.view endEditing:YES];
    _getCodeButton.titleLabel.font = [UIFont systemFontOfSize:10];
    CGSize titleSize = [sender.titleLabel.text boundingRectWithSize:CGSizeMake(kScreenSize.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]} context:nil].size;
    
    [UIView animateWithDuration:0.2 animations:^{
        _getCodeButton.frame = CGRectMake(kScreenSize.width - 30 - titleSize.width, _textFieldCode.orginY, titleSize.width, _textFieldCode.sizeHeight);
        
        _textFieldCode.alpha = 1;
        _loginButton.alpha = 1;
        [self lockedGetCodeButton:_loginButton];
        [self sendSmsFun];
    }];
    
}

//点击登录
- (IBAction)loginButtonClick:(UIButton *)sender {
    [self verifyCodeFun];
}

- (void)textAfClient{
    [[AFClient shareInstance] chackVersonProgressBlock:^(NSProgress *progress) {
        
    } success:^(id responseBody) {
        if ([responseBody[@"code"] integerValue] == 200) {
            NSLog(@"%@",responseBody[@"data"]);
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)sendSmsFun{
    [[AFClient shareInstance] signCodeByMobile:_textFieldMobile.text progressBlock:^(NSProgress *progress) {
        
    } success:^(id responseBody) {
        if ([responseBody[@"code"] integerValue] == 200) {
            NSLog(@"%@",responseBody[@"data"]);
            _timeCount = 60;
            _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeRun) userInfo:nil repeats:YES];
            [_timer setFireDate:[NSDate distantPast]];
            kAlert(@"验证码已发送");
            [_textFieldCode becomeFirstResponder];
//            [self hiddenView];
        }else{
            kAlert(responseBody[@"message"]);
        }

    } failure:^(NSError *error) {
        
    }];
}

- (void)timeRun{
    [self lockedGetCodeButton:_getCodeButton];
    _timeCount --;
    NSString *title = [NSString stringWithFormat:@"重新获取(%.lfs)",_timeCount];
    CGSize titleSize = [title boundingRectWithSize:CGSizeMake(kScreenSize.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]} context:nil].size;
    _getCodeButton.frame = CGRectMake(kScreenSize.width - 30 - titleSize.width, _textFieldCode.orginY, titleSize.width, _textFieldCode.sizeHeight);
    _getCodeButton.titleLabel.text = title;
    [_getCodeButton setTitle:title forState:UIControlStateNormal];
    if (_timeCount < 1) {
        NSString *title = @"再次发送";
        _getCodeButton.titleLabel.text = title;
        [_getCodeButton setTitle:title forState:UIControlStateNormal];
        [_timer setFireDate:[NSDate distantFuture]];
        
        [self unlockedGetCodeButton:_getCodeButton];
    }
}

- (void)verifyCodeFun{
    _hud = [MBProgressHUD showHUDAddedTo:kWindowLastPage animated:YES];
    // Set the label text.
    _hud.label.text = NSLocalizedString(@"正在登录...", @"HUD loading title");
    [[AFClient shareInstance] chackCodeByMobile:_textFieldMobile.text code:_textFieldCode.text progressBlock:^(NSProgress *progress) {
        
    } success:^(id responseBody) {
        [_hud hideAnimated:YES];
        if ([responseBody[@"code"] integerValue] == 200) {
            [[NSUserDefaults standardUserDefaults] setValue:responseBody[@"data"][@"id"] forKey:@"Id"];
            [[NSUserDefaults standardUserDefaults] setValue:responseBody[@"data"][@"mobile"] forKey:@"mobile"];

            //判断是否是VIP

            [self hiddenView];
            
        }else{
            kAlert(responseBody[@"message"]);
        }
    } failure:^(NSError *error) {
        
    }];
}


- (void)hiddenView{
    [[AFClient shareInstance] hiddenViewProgressBlock:nil success:^(id responseBody) {
        if ([responseBody[@"code"] integerValue] ==200) {
            [[NSUserDefaults standardUserDefaults] setValue:responseBody[@"data"] forKey:@"isHiddenValue"];
            
            [[AFClient shareInstance] empowerByUserId:kUserId udid:UDID progressBlock:^(NSProgress *progress) {
                
            } success:^(id responseBody) {
                //                [_hud hideAnimated:YES];
                [[NSUserDefaults standardUserDefaults] setValue:responseBody[@"code"] forKey:@"isVip"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"login" object:nil];
                
            } failure:^(NSError *error) {
                
            }];
        }
    } failure:^(NSError *error) {
        
    }];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
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
