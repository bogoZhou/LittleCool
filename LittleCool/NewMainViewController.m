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

@interface NewMainViewController ()<ImagePlayerViewDelegate>
{
    
}
@property (nonatomic, strong) NSMutableArray *imageURLs;
@property (nonatomic, strong) NSCache *imageCache;
@property (nonatomic,strong) NSMutableArray *bannerArray;
@end

@implementation NewMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self UISetting];
    _bannerArray = [NSMutableArray array];
    [self loadBannerFun];
    [self hiddenView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = YES;
}

- (void)UISetting{
    CGFloat alf = 0.7;
    _centerViewSounds.layer.masksToBounds = YES;
    _centerViewSounds.layer.cornerRadius = 5;
    _viewSounds.backgroundColor = [kColorFrom0x(0xf02f93) colorWithAlphaComponent:alf];
    
    _centerViewImage.layer.masksToBounds = YES;
    _centerViewImage.layer.cornerRadius = 5;
    _viewImage.backgroundColor = [kColorFrom0x(0xf0662f) colorWithAlphaComponent:alf];
    
    _centerViewCoolImage.layer.masksToBounds = YES;
    _centerViewImage.layer.cornerRadius = 5;
    _viewCoolImage.backgroundColor = [kColorFrom0x(0xf0662f) colorWithAlphaComponent:alf];
}

- (void)creatBanner{
    _imageCache = [NSCache new];
    
//    self.imageURLs = @[[NSURL URLWithString:@"http://sudasuta.com/wp-content/uploads/2013/10/10143181686_375e063f2c_z.jpg"],
//                       [NSURL URLWithString:@"http://img01.taopic.com/150920/240455-1509200H31810.jpg"],
//                       [NSURL URLWithString:@"http://img.taopic.com/uploads/allimg/110906/1382-110Z611025585.jpg"]];
    
//    self.imageURLs = @[@"1-1.png",@"2-1.png",@"3-1.png",@"4.png"];
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
    UIStoryboard *storyboard = kMainStroyboard;
    MainViewController *mainVC = [storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
    [self.navigationController pushViewController:mainVC animated:YES];
}

//图片素材
- (IBAction)pictureButtonClick:(UIButton *)sender {
    UIStoryboard *storyboard = kMainStroyboard;
    PicturesViewController *picVC = [storyboard instantiateViewControllerWithIdentifier:@"PicturesViewController"];
    [self.navigationController pushViewController:picVC animated:YES];
}

//逗图制作
- (IBAction)coolPicMakeButtonClick:(UIButton *)sender {
    kAlert(@"逗图制作");
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
