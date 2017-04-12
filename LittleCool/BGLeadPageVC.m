//
//  BGLeadPageVC.m
//  test
//
//  Created by 周博 on 15/11/21.
//  Copyright © 2015年 周博. All rights reserved.
//

#import "BGLeadPageVC.h"
#import "BGControl.h"
#import "MCPagerView.h"

#define kTime 2.f
@interface BGLeadPageVC ()<UIScrollViewDelegate,MCPagerViewDelegate>
{
    NSInteger timeCount;
    
    NSInteger _hiddenValue;
}
@property (nonatomic,strong) UIView *launchScreen;

@property (nonatomic,strong) UIScrollView *mainScrollView;
@property (nonatomic,strong) NSArray *picArray;
@property (nonatomic,strong) NSURLSessionTask *downloadTask;
@property (nonatomic,strong) UIPageControl *pageControl;
@property (nonatomic,strong) MCPagerView *pagerView;

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
    self.picArray = @[@"1.png",@"2.png",@"3.png"];
    
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
            
            UIView *inView = [[UIView alloc] initWithFrame:CGRectMake(kScreenSize.width/2 - 80, kScreenSize.height - 150, 160, 50)];
            inView.layer.masksToBounds = YES;
            inView.layer.cornerRadius = 10;
            inView.layer.borderColor = [[UIColor groupTableViewBackgroundColor] CGColor];
            inView.layer.borderWidth = 1.f;
            inView.backgroundColor = [kWhiteColor colorWithAlphaComponent:0.5];
            
            UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, inView.sizeWidth, inView.sizeHeight)];
            contentLabel.font = [UIFont systemFontOfSize:20];
            contentLabel.text = @"立即体验";
            contentLabel.textAlignment = NSTextAlignmentCenter;
            contentLabel.textColor = kColorFrom0x(0xd53c3e);
            [inView addSubview:contentLabel];
            [imageView addSubview:inView];
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
            button.frame = CGRectMake(0, 0, kScreenSize.width, kScreenSize.height);
            [button addTarget:self action:@selector(scrollViewButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [imageView addSubview:button];
            imageView.userInteractionEnabled = YES;
        }
        [self.mainScrollView addSubview:imageView];
    }
//    //创建UIPageControl
//    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, kScreenSize.height - 80, kScreenSize.width, 30)];  //创建UIPageControl，位置在屏幕最下方。
//    _pageControl.userInteractionEnabled = YES;
//    [_pageControl setValue:[UIImage imageNamed:@"red-p"] forKeyPath:@"_pageImage"];
//    
//    [_pageControl setValue:[UIImage imageNamed:@"write-p"] forKeyPath:@"_currentPageImage"];
//    _pageControl.numberOfPages = _picArray.count;//总的图片页数
//    _pageControl.currentPage = 0; //当前页
//    [_pageControl addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];  //用户点击UIPageControl的响应函数
    [self.view addSubview:self.mainScrollView];
//    [self.view addSubview:_pageControl];  //将UIPageControl添加到主界面上。
    
    // Pager
    _pagerView = [[MCPagerView alloc] initWithFrame:CGRectMake(kScreenSize.width/2 - 55, kScreenSize.height - 80, 100, 30)];
    [_pagerView setImage:[UIImage imageNamed:@"white-p"]
       highlightedImage:[UIImage imageNamed:@"red-p"]
                 forKey:@"a"];
    [_pagerView setImage:[UIImage imageNamed:@"white-p"]
        highlightedImage:[UIImage imageNamed:@"purple-p"]
                  forKey:@"b"];
    [_pagerView setImage:[UIImage imageNamed:@"white-p"]
        highlightedImage:[UIImage imageNamed:@"orange-p"]
                  forKey:@"c"];
    
    [_pagerView setPattern:@"abc"];
    
    _pagerView.delegate = self;
    [self.view addSubview:_pagerView];
}

- (void)updatePager
{
    _pagerView.page = floorf(_mainScrollView.contentOffset.x / _mainScrollView.frame.size.width);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self updatePager];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [self updatePager];
    }
}

- (void)pageView:(MCPagerView *)pageView didUpdateToPage:(NSInteger)newPage
{
    CGPoint offset = CGPointMake(_mainScrollView.frame.size.width * _pagerView.page, 0);
    [_mainScrollView setContentOffset:offset animated:YES];
}

- (void)viewDidUnload
{
    _pagerView = nil;
    _mainScrollView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

////其次是UIScrollViewDelegate的scrollViewDidEndDecelerating函数，用户滑动页面停下后调用该函数。
//
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    //更新UIPageControl的当前页
//    CGPoint offset = scrollView.contentOffset;
//    CGRect bounds = scrollView.frame;
//    [_pageControl setCurrentPage:offset.x / bounds.size.width];
//    NSLog(@"%f",offset.x / bounds.size.width);
//}

//然后是点击UIPageControl时的响应函数pageTurn
- (void)pageTurn:(UIPageControl*)sender
{
    //令UIScrollView做出相应的滑动显示
    CGSize viewSize = _mainScrollView.frame.size;
    CGRect rect = CGRectMake(sender.currentPage * viewSize.width, 0, viewSize.width, viewSize.height);
    [_mainScrollView scrollRectToVisible:rect animated:YES];
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
