//
//  MainViewController.m
//  LittleCool
//
//  Created by 周博 on 17/3/12.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "MainViewController.h"
#import "BGCollectionView.h"
#import "CitysModel.h"
#import "VideosModel.h"
#import "ChooseLabelViewController.h"
#import "SearchViewController.h"
#import "ZLPhoto.h"
#import <MediaPlayer/MediaPlayer.h>
#import "UIImageView+WebCache.h"
#import "MainDetailViewController.h"

#define kPageSize @"1000"

@interface MainViewController ()<UISearchBarDelegate,ZLPhotoPickerViewControllerDelegate>
{
    NSString *_labelTag;
    NSInteger _pageIndex;
    NSString *_buttonTag;
}
@property (nonatomic,strong) UISwipeGestureRecognizer *rightMoveGesture;
@property (nonatomic,strong) UISwipeGestureRecognizer *leftMoveGesture;

@property (nonatomic,strong) NSMutableArray *myDataArray;
@property (nonatomic,strong) NSMutableArray *cityArray;
@property (nonatomic,strong) BGCollectionView *collectionView;
@property (nonatomic , strong) NSMutableArray *assets;
@property (nonatomic,strong) MBProgressHUD *hud;


@end

@implementation MainViewController
-(void)setMyDataArray:(NSMutableArray *)myDataArray{
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
//    [self creatTabBar];
    // Do any additional setup after loading the view.
    [self firstStept];
    [self getNoti];
    [self creatCollectionView];
    [self creatGestureRight];
    [self loadCityList];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    [self.view bringSubviewToFront:_tabBarView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)firstStept{
    _searchBar.backgroundImage = [UIImage new];
    
    UITextField *textField = [_searchBar valueForKey:@"_searchField"];
    textField.layer.masksToBounds = YES;
    textField.layer.borderWidth = 1;
    textField.layer.borderColor = [kColorFrom0x(0xf4f4f4) CGColor];
    textField.layer.cornerRadius = kButtonCornerRadius *2;
    
    
    _myDataArray = [NSMutableArray array];
    _cityArray = [NSMutableArray array];
    
}


#pragma mark - loadData
- (void)loadCityList{
    [[AFClient shareInstance] getAllCityByUserId:kUserId udid:UDID progressBlock:^(NSProgress *progress) {
        
    } success:^(id responseBody) {
        if ([responseBody[@"code"] integerValue] == 200) {
            
            for (NSDictionary *dic in responseBody[@"data"]) {
                CitysModel *cityModel = [[CitysModel alloc] init];
                [cityModel setValuesForKeysWithDictionary:dic];
                [_cityArray addObject:cityModel];
            }
            [self creatCityListView];

        }else{
            kAlert(responseBody[@"message"]);
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)loadVideosListData{
        _hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
        // Set the label text.
        _hud.label.text = NSLocalizedString(@"加载中...", @"HUD loading title");
    NSString *pageIndex = [NSString stringWithFormat:@"%ld",_pageIndex];
    NSLog(@"%@",UDID);
    [[AFClient shareInstance] getVideosByUserId:kUserId udid:UDID label_id:_labelTag title:@"" page_index:pageIndex page_size:kPageSize progressBlock:^(NSProgress *progress) {
        
    } success:^(id responseBody) {
        if ([responseBody[@"code"] integerValue] == 200) {
            if (_pageIndex == 0) {
                [_myDataArray removeAllObjects];
            }
            for (NSDictionary *dic in responseBody[@"data"]) {
                VideosModel *model = [[VideosModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_myDataArray addObject:model];
            }
            [_collectionView reloadDataByArray:_myDataArray];
            [_hud hideAnimated:YES];
        }
    } failure:^(NSError *error) {
        
    }];
}


- (void)creatCityListView{
    CGFloat allWidth = 0;
    for (int i = 0; i < _cityArray.count; i ++) {
        UIView *cityView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, _scrollView.sizeHeight)];
        cityView.backgroundColor = kWhiteColor;
        
        CitysModel *model = _cityArray[i];
        
        CGSize titleSize = [model.name boundingRectWithSize:CGSizeMake(200, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size;
        
        cityView.frame = CGRectMake(allWidth, 0, titleSize.width + 30, _scrollView.sizeHeight);
        cityView.tag = 3000 +i;
        allWidth += cityView.sizeWidth;
        
        [_scrollView addSubview:cityView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, cityView.sizeWidth, cityView.sizeHeight)];
        titleLabel.text = model.name;
        titleLabel.tag = 1000 + i;
        titleLabel.font = [UIFont systemFontOfSize:17];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [cityView addSubview:titleLabel];
        
        UIButton *titleButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, cityView.sizeWidth, cityView.sizeHeight)];
        titleButton.tag = 2000 + i;
        [titleButton addTarget:self action:@selector(chooseCityItemsButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [cityView addSubview:titleButton];
    }
    _scrollView.contentSize = CGSizeMake(allWidth, _scrollView.sizeHeight);
    UIButton *button = (UIButton *)[self.view viewWithTag:2000];
    [self chooseCityItemsButtonClick:button];
}

- (void)chooseCityItemsButtonClick:(UIButton *)button{
    _buttonTag = [NSString stringWithFormat:@"%ld",button.tag-2000];
    for (int i = 0 ; i < _cityArray.count; i ++) {
        UILabel *label = (UILabel *)[self.view viewWithTag:1000 + i];
        label.textColor = kColorFrom0x(0x000000);
    }
    
    UILabel *label = (UILabel *)[self.view viewWithTag:button.tag - 1000];
    label.textColor = kColorFrom0x(0x529df4);
    
    UIView *cityView = (UIView *)[self.view viewWithTag:button.tag + 1000];
    
    CitysModel *model = _cityArray[button.tag - 2000];
    _labelTag = model.id;
    [_scrollView setContentOffset:CGPointMake(cityView.orginX - (_scrollView.center.x - cityView.sizeWidth/2), label.orginY) animated:YES];
    
//    [_scrollView setContentOffset:CGPointMake((_scrollView.contentSize.width / _cityArray.count)* (button.tag - 2000), label.orginY) animated:YES];
    [self loadVideosListData];
    if (button.tag < 2003) {
        [_scrollView setContentOffset:CGPointMake(0, label.orginY) animated:YES];
    }
    if (button.tag > 2000 + _cityArray.count - 1 - 2) {
        [_scrollView setContentOffset:CGPointMake(_scrollView.contentSize.width - _scrollView.sizeWidth, label.orginY) animated:YES];
    }
}

- (void)creatCollectionView{
    _collectionView = [[BGCollectionView alloc] initWithFrame:CGRectMake(0, _scrollView.allHeight, kScreenSize.width, kScreenSize.height -_scrollView.allHeight - 49)withDataArray:_myDataArray];
    [self.view addSubview:_collectionView];
}

#pragma mark - 点击事件

- (IBAction)rightButtonClick:(UIButton *)sender {
    self.tabBarController.selectedIndex = 1;
}

- (IBAction)centerButtonClick:(UIButton *)sender {
    NSString *vip = kIsVip;
    if ([vip integerValue] == 200) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *selectVideoAction = [UIAlertAction actionWithTitle:@"从相册选择视频" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self selectPhotos];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:selectVideoAction];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
//        只有授权用户才可以使用哦
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"只有授权用户才可以使用哦" message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"知道啦" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (IBAction)chooseCityButtonClick:(UIButton *)sender {
//    kAlert(@"点击弹出选择城市列表");
    
    CATransition * animation = [CATransition animation];
    
    animation.duration = 0.5;    //  时间
    
    /**  type：动画类型
     *  pageCurl       向上翻一页
     *  pageUnCurl     向下翻一页
     *  rippleEffect   水滴
     *  suckEffect     收缩
     *  cube           方块
     *  oglFlip        上下翻转
     */
    animation.type = @"pageCurl";
    
    /**  type：页面转换类型
     *  kCATransitionFade       淡出
     *  kCATransitionMoveIn     覆盖
     *  kCATransitionReveal     底部显示
     *  kCATransitionPush       推出
     */
    animation.type = kCATransitionPush;
    
    //PS：type 更多效果请 搜索： CATransition
    
    /**  subtype：出现的方向
     *  kCATransitionFromRight       右
     *  kCATransitionFromLeft        左
     *  kCATransitionFromTop         上
     *  kCATransitionFromBottom      下
     */
    animation.subtype = kCATransitionFromBottom;
    
    [self.view.window.layer addAnimation:animation forKey:nil];
    
    UIStoryboard *storyboard = kMainStroyboard;
    ChooseLabelViewController *chooseLabelVC = [storyboard instantiateViewControllerWithIdentifier:@"ChooseLabelViewController"];
    chooseLabelVC.dataArray = _cityArray;
    chooseLabelVC.buttonTag = _buttonTag;
    [self presentViewController:chooseLabelVC animated:YES completion:nil];
}

#pragma mark - searchBar
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
//    kAlert(@"点击了searchBar");
    UIStoryboard *storyboard = kMainStroyboard;
    SearchViewController *searchVC = [storyboard instantiateViewControllerWithIdentifier:@"SearchViewController"];
//    [self presentViewController:searchVC animated:YES completion:nil];
    [self.navigationController pushViewController:searchVC animated:YES];
    return NO;
}

#pragma mark - getNoti

- (void)getNoti{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getItemNoti:) name:@"chooseItem" object:nil];
}

#pragma mark - 通知方法

- (void)getItemNoti:(NSNotification *)noti{
    NSString *buttonTag = noti.object;
    UIButton *button = [self.view viewWithTag:buttonTag.integerValue + 2000];
    [self chooseCityItemsButtonClick:button];
}



#pragma mark - 侧滑手势
/**
 *  添加手势
 */
- (void)creatGestureRight{
    self.rightMoveGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightMove)];
    self.rightMoveGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:self.rightMoveGesture];
    
    self.leftMoveGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftMove)];
    self.leftMoveGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:self.leftMoveGesture];
}

- (void)rightMove{
    if (_buttonTag.integerValue > 0) {
        UIButton *button = (UIButton *)[self.view viewWithTag:_buttonTag.integerValue  +2000 - 1];
        [self chooseCityItemsButtonClick:button];
    }
}

- (void)leftMove{
    if (_buttonTag.integerValue < _cityArray.count-1) {
        UIButton *button = (UIButton *)[self.view viewWithTag:_buttonTag.integerValue + 1 +2000];
        [self chooseCityItemsButtonClick:button];
    }
}


#pragma mark - select Photo Library
- (void)selectPhotos {
    // 创建控制器
    ZLPhotoPickerViewController *pickerVc = [[ZLPhotoPickerViewController alloc] init];
    // 默认显示相册里面的内容SavePhotos
    // 最多能选9张图片
    pickerVc.maxCount = 1;
    pickerVc.status = PickerViewShowStatusVideo;
    pickerVc.delegate = self;
    [pickerVc showPickerVc:self];
    /**
     *
     传值可以用代理，或者用block来接收，以下是block的传值
     __weak typeof(self) weakSelf = self;
     pickerVc.callBack = ^(NSArray *assets){
     weakSelf.assets = assets;
     [weakSelf.tableView reloadData];
     };
     */
}

- (void)pickerViewControllerDoneAsstes:(NSArray *)assets{
    self.assets = [NSMutableArray array];
    [self.assets addObjectsFromArray:assets];
    ZLPhotoAssets *ass = self.assets.lastObject;
    
    
    ALAssetRepresentation *representation = ass.asset.defaultRepresentation;
    if (ass.isVideoType) {
        long long size = representation.size;
        NSMutableData* data = [[NSMutableData alloc] initWithCapacity:size];
        void* buffer = [data mutableBytes];
        [representation getBytes:buffer fromOffset:0 length:size error:nil];
        NSData *fileData = [[NSData alloc] initWithBytes:buffer length:size];

        //File URL
        NSString *savePath = [NSString stringWithFormat:@"%@%@", [NSHomeDirectory() stringByAppendingString:@"/Documents/"], representation.filename];
        [[NSFileManager defaultManager] removeItemAtPath:savePath error:nil];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void)   {
            [fileData writeToFile:savePath atomically:NO];
//            kAlert(outPutFilePath);
            UIStoryboard *storyboard = kMainStroyboard;
            MainDetailViewController *detailVC = [storyboard instantiateViewControllerWithIdentifier:@"MainDetailViewController"];
            VideosModel * model = [[VideosModel alloc] init];
            model.id = [representation.filename substringToIndex:representation.filename.length - 4];
            model.url = savePath;
            model.localUrl = ass.asset.defaultRepresentation.url;
            detailVC.model = model;
            detailVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:detailVC animated:YES];
        });
        
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
