//
//  BGLeadPageVC.m
//  test
//
//  Created by 周博 on 15/11/21.
//  Copyright © 2015年 周博. All rights reserved.
//

#import "BGLeadPageVC.h"
#import "BGControl.h"

#define kTime 2.f
@interface BGLeadPageVC ()<UIScrollViewDelegate>
{
    NSInteger timeCount;
    
    NSInteger _hiddenValue;
}
@property (nonatomic,strong) UIView *launchScreen;

@property (nonatomic,strong) UIScrollView *mainScrollView;
@property (nonatomic,strong) NSArray *picArray;
@property (nonatomic,strong) NSURLSessionTask *downloadTask;
@end

@implementation BGLeadPageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

//    [self changeColor];
    
//    NSString *isFirst = [[NSUserDefaults standardUserDefaults] valueForKey:@"FIRST"];
//    if ([isFirst integerValue] < 1) {
        [self hiddenView];
//    }else{
////        [self creatLaunchScreen];
//        [self hiddenView];
//    }
    
}



- (void)viewWillAppear:(BOOL)animated{
}

/**
 *  创建启动页
 */
- (void)creatLaunchScreen{
    
    NSString *imageName = @"loading页2.png";
    
    self.launchScreen = [BGControl creatViewWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height) backgroundColor:[UIColor whiteColor] isLayer:NO cornerRadius:0];
    UIImageView * imageView = [BGControl creatImageViewWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height) image:imageName isWebImage:NO holdOnImage:nil isLayer:NO cornerRadius:0];
    [self.launchScreen addSubview:imageView];
    [self.view addSubview:self.launchScreen];
    
    [NSTimer scheduledTimerWithTimeInterval:kTime target:self selector:@selector(countTimes) userInfo:nil repeats:NO];
}

/**
 *  计时器的选择事件
 */
- (void)countTimes{
    [UIView animateWithDuration:1.0f animations:^{
        self.launchScreen.alpha = 1;
    }];
    [self hiddenView];
}

- (void)hiddenView{
//    [self isFirstLogin:_hiddenValue];
//    [[AFClient shareInstance] hiddenViewProgressBlock:^(NSProgress *progress) {
//        
//    } success:^(id responseBody) {
//        if ([responseBody[@"code"] integerValue]== 200) {
//            _hiddenValue = [responseBody[@"data"] integerValue];
//            [self isFirstLogin:_hiddenValue];
//        }
//    } failure:^(NSError *error) {
//        
//    }];
    _hiddenValue = 1;
    [self isFirstLogin:_hiddenValue];

}

/**
 *  创建滚动视图  -> 引导页
 */
- (void)creatMainScrollView{
    self.picArray = [NSArray array];
    self.picArray = @[@"1.jpg",@"2.jpg",@"3.jpg"];
    
    self.mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height)];
    self.mainScrollView.contentSize = CGSizeMake(kScreenSize.width * self.picArray.count, kScreenSize.height);
    //设置 分成不同页面
    self.mainScrollView.pagingEnabled = YES;
    //代理
    self.mainScrollView.delegate = self;
    //设置是否可以左右滑动
    self.mainScrollView.showsHorizontalScrollIndicator = NO;
    self.mainScrollView.showsVerticalScrollIndicator = NO;
    //设置反弹动画
    self.mainScrollView.bounces = NO;
    //背景颜色
    self.mainScrollView.backgroundColor = [UIColor whiteColor];
    //是否 可翻页
    self.mainScrollView.delaysContentTouches = YES;
    //触摸事件
    self.mainScrollView.canCancelContentTouches = NO;
    //用户交互
    self.mainScrollView.userInteractionEnabled = YES;
    
    //循环将粘有button的imageView 粘贴到scrollView上
    for (NSInteger i = 0; i < self.picArray.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * kScreenSize.width, 0, kScreenSize.width, kScreenSize.height)];
        
        imageView.image = [UIImage imageNamed:self.picArray[i]];
        
        if (self.picArray.count - 1 == i) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
            button.frame = CGRectMake(0, 0, kScreenSize.width, kScreenSize.height);
            [button addTarget:self action:@selector(scrollViewButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [imageView addSubview:button];
            imageView.userInteractionEnabled = YES;
        }
        [self.mainScrollView addSubview:imageView];
    }
    [self.view addSubview:self.mainScrollView];
}

/**
 *  是否是第一次登录
 */
- (void)isFirstLogin:(NSInteger)isHidden{
    NSString * isFirst = [[NSUserDefaults standardUserDefaults] valueForKey:@"FIRST"];
    if (isFirst.integerValue < 1) {
        [self creatMainScrollView];
    }else{
        if ([kUserId integerValue] > 0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"login" object:nil];
            [[NSUserDefaults standardUserDefaults] setValue:[DLUDID value] forKey:@"UDID"];
        }else{
            if (isHidden < 0) {
//                [DLUDID value];
                [[NSUserDefaults standardUserDefaults] setValue:@"D9FD7F9AE7DE4B35A40982DC9315095A" forKey:@"UDID"];
                [[NSUserDefaults standardUserDefaults] setValue:@"490" forKey:@"Id"];
                [[NSUserDefaults standardUserDefaults] setValue:@"18937853839" forKey:@"mobile"];
                [[NSUserDefaults standardUserDefaults] setValue:@"200" forKey:@"isVip"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"login" object:nil];
            }else{
                [[NSUserDefaults standardUserDefaults] setValue:[DLUDID value] forKey:@"UDID"];
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"sign" object:nil];
            }
        }
    }
}

/**
 *  滚动视图最后一张的点击事件
 */
- (void)scrollViewButtonClick:(UIButton *)button{
    [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"FIRST"];
    if ([kUserId integerValue] > 0) {
        [[NSUserDefaults standardUserDefaults] setValue:[DLUDID value] forKey:@"UDID"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"login" object:nil];
    }else{
        if (_hiddenValue < 0) {
            [[NSUserDefaults standardUserDefaults] setValue:@"D9FD7F9AE7DE4B35A40982DC9315095A" forKey:@"UDID"];
            [[NSUserDefaults standardUserDefaults] setValue:@"490" forKey:@"Id"];
            [[NSUserDefaults standardUserDefaults] setValue:@"18937853839" forKey:@"mobile"];
            [[NSUserDefaults standardUserDefaults] setValue:@"200" forKey:@"isVip"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"login" object:nil];
        }else{
            [[NSUserDefaults standardUserDefaults] setValue:[DLUDID value] forKey:@"UDID"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"sign" object:nil];
        }
    }
}

#pragma mark 自动登录
/**
 *  自动登录
 *
 *  @param mobile 如果登录过,会从本地获取文件取出 mobile 的值,完成自动登录
 */
- (void)autoLogin{
    
    if ([kUserId integerValue] > 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"login" object:nil];
    }else{
        [self scrollViewButtonClick:nil];
    }
}

/**
 *  获取用户信息并保存
 *
 *  @param dic 存有用户信息的字典
 */
- (void)getUserInfoByDictionory:(NSDictionary *)dic{
 }

/**
 *  检测本地存储的 APP 版本   和判断时候是第一次登录
 */
- (void)deviceInfo{
    NSString *fileName = [BGFunctionHelper filePath:@"deviceInfo.plist"];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:fileName];
    if (![dict[@"isSave"] isEqualToString:@"YES"] ||
        [BGFunctionHelper isNULLOfString:dict[@"softwareVersion"]] ||
        ![kSoftwareVersion isEqualToString:dict[@"softwareVersion"]]) {
        [self getDeviceInfo];
    }
}

/**
 *  获取用户设备信息
 */
- (void)getDeviceInfo{
//    NSString *userId = kUserId;
//    [[AFClient shareInstance] updataPhoneInfoByUserId:userId deviceType:@"1" brand:@"APPLE" model:[BGControl deviceVersion] versionSdk:[BGControl getCurrentIOS] versionRelease:[BGControl getCurrentIOS] softwareVersion:kSoftwareVersion success:^(id responseBody) {
//        if ([responseBody[@"code"] integerValue] == 200) {
//            [self saveGetDeviceInfo];
//        }
//    } failure:^(NSError *error) {
//        
//    }];
}

/**
 *  更新成功后 存 是否是第一次登录 和 版本号
 */
- (void)saveGetDeviceInfo{
    NSString *fileName = [BGFunctionHelper filePath:@"deviceInfo.plist"];
    NSMutableDictionary *saveDic = [[NSMutableDictionary alloc] init];
    saveDic = [BGFunctionHelper saveUserInfoInDictionary:saveDic key:@"isSave" value:@"YES"];
    saveDic = [BGFunctionHelper saveUserInfoInDictionary:saveDic key:@"softwareVersion" value:kSoftwareVersion];
    [saveDic writeToFile:fileName atomically:YES];
    //    [self testAlertView:[NSString stringWithFormat:@"%@",[BGControl getCurrentIOS]]];
}


///**
// *  从本地读取 userId
// *
// *  @return 返回读取到的 userId
// */
//- (NSString *)getUserId{
//    NSString *fileName = [BGControl filePath:@"TokenAndId.plist"];
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithContentsOfFile:fileName];
//    NSString *userId = [dic[@"userId"] stringValue];
//    return userId;
//}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
//    [GetUserInfo removeUserInfo];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"sign" object:nil];
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
