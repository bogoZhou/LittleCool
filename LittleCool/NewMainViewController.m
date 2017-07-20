//
//  NewMainViewController.m
//  LittleCool
//
//  Created by 周博 on 17/4/10.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "NewMainViewController.h"
#import "MainViewController.h"
#import "PicturesViewController.h"
#import "BannerModel.h"
#import "WebViewController.h"
#import "WechatTabBarViewController.h"
#import "NewMainTableViewCell.h"
#import "PosterMainViewController.h"

#define kCellName @"NewMainTableViewCell"

@interface NewMainViewController ()<ImagePlayerViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    
}
@property (nonatomic,strong) UIView *shuiyinView;

@property (nonatomic, strong) NSMutableArray *imageURLs;
@property (nonatomic, strong) NSCache *imageCache;
@property (nonatomic,strong) NSMutableArray *bannerArray;

@property (nonatomic,strong) NSArray *itemsArray;

@end

@implementation NewMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _itemsArray = [NSArray array];
    [self UISetting];
    _bannerArray = [NSMutableArray array];
    [self loadBannerFun];
//    [self hiddenView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self shuiyin:YES];
}

- (void)UISetting{
    _itemsArray = @[@[@"百变配音",[UIImage imageNamed:@"voice02.png"],kColorFrom0x(0xf02f93)]
                    ,@[@"图片素材",[UIImage imageNamed:@"picture-material.png"],kColorFrom0x(0xf0662f)]
                    ,@[@"逗图制作",[UIImage imageNamed:@"make-drawing.png"],kColorFrom0x(0xfb111df)]
                    ,@[@"海报制作",[UIImage imageNamed:@"posters-produced.png"],kColorFrom0x(0x3d2ff0)]
                    ];
    [_tableView reloadData];
}

- (void)creatBanner{
    _imageCache = [NSCache new];

    _imageURLs = [NSMutableArray array];
    for (BannerModel *bannerModel in _bannerArray) {
        [self.imageURLs addObject:bannerModel.img_url];
    }
    
    self.viewBanner.imagePlayerViewDelegate = self;
    
    // set auto scroll interval to x seconds
    self.viewBanner.scrollInterval = 3.0f;
    
    // adjust pageControl position
    self.viewBanner.pageControlPosition = ICPageControlPosition_BottomCenter;
    
    // hide pageControl or not
    self.viewBanner.hidePageControl = NO;
    
    // endless scroll
    self.viewBanner.endlessScroll = YES;
    
    // adjust edgeInset
    self.viewBanner.edgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    
    [self.viewBanner reloadData];
}

#pragma mark - 下载数据
- (void)loadBannerFun{
    [[AFClient shareInstance] getBunnerByUserId:kUserId udid:UDID progressBlock:nil success:^(id responseBody) {
        if ([responseBody[@"code"] integerValue] == 200) {
            NSLog(@"%@",responseBody);
            for (NSDictionary *dic in responseBody[@"data"]) {
                BannerModel *model = [[BannerModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_bannerArray addObject:model];
            }
            [self creatBanner];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)hiddenView{
    [[AFClient shareInstance] hiddenViewProgressBlock:nil success:^(id responseBody) {
        if ([responseBody[@"code"] integerValue] ==200) {
            [[NSUserDefaults standardUserDefaults] setValue:responseBody[@"data"] forKey:@"isHiddenValue"];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - 点击事件

- (IBAction)mineButtonClick:(UIButton *)sender {
    self.tabBarController.selectedIndex = 1;
}

//配音
- (IBAction)soundsButtonClick:(UIButton *)sender {

}

//图片素材
- (IBAction)pictureButtonClick:(UIButton *)sender {

}

//逗图制作
- (IBAction)coolPicMakeButtonClick:(UIButton *)sender {

}


#pragma mark - ImagePlayerViewDelegate
- (NSInteger)numberOfItems
{
    return self.imageURLs.count;
}

- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView loadImageForImageView:(UIImageView *)imageView index:(NSInteger)index
{

    [imageView sd_setImageWithURL:self.imageURLs[index] placeholderImage:[UIImage imageNamed:@"banner_bg"]];

}

- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView didTapAtIndex:(NSInteger)index
{
//    NSLog(@"did tap index = %d", (int)index);
    BannerModel *model = _bannerArray[index];
    if (![BGFunctionHelper isNULLOfString:model.redirect_link]) {
        UIStoryboard *storyboard = kMainStroyboard;
        WebViewController *webVC = [storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
        webVC.jumpUrl =model.redirect_link;
        [self.navigationController pushViewController:webVC animated:YES];
    }
    
}

#pragma mark - 水印

- (void)shuiyin:(BOOL)isHidden{
    if (isHidden) {
        [_shuiyinView removeFromSuperview];
        _shuiyinView = nil;
    }else{
        _shuiyinView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height)];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
        imageView.image = [UIImage imageNamed:@"有点逗水印"];
        imageView.center = _shuiyinView.center;
        [_shuiyinView addSubview:imageView];
        _shuiyinView.userInteractionEnabled = NO;
        [[[UIApplication sharedApplication] keyWindow] addSubview:_shuiyinView];
    }
    
}

#pragma mark - tableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _itemsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellName];
    NSArray *itemArray = _itemsArray[indexPath.row];
    [cell UISettingByColor:itemArray[2] title:itemArray[0] image:itemArray[1]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        UIStoryboard *storyboard = kMainStroyboard;
        MainViewController *mainVC = [storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
        [self.navigationController pushViewController:mainVC animated:YES];
    }else if (indexPath.row == 1){
        UIStoryboard *storyboard = kMainStroyboard;
        PicturesViewController *picVC = [storyboard instantiateViewControllerWithIdentifier:@"PicturesViewController"];
        [self.navigationController pushViewController:picVC animated:YES];
    }else if (indexPath.row == 2){
        UIStoryboard *storyboard = kWechatStroyboard;
        WechatTabBarViewController *wechatTBB = [storyboard instantiateViewControllerWithIdentifier:@"WechatTabBarViewController"];
        NSString *isVIP = kIsVip;
        if (isVIP.integerValue == 200) [self shuiyin:YES];
        else[self shuiyin:NO];
        [self.navigationController pushViewController:wechatTBB animated:YES];
    }else{
//        kAlert(@"海报制作");
        UIStoryboard *storyboard = kPosterStoryboard;
        PosterMainViewController * posterMainVC = [storyboard instantiateViewControllerWithIdentifier:@"PosterMainViewController"];
        posterMainVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:posterMainVC animated:YES];
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
