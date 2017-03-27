//
//  MineViewController.m
//  LittleCool
//
//  Created by 周博 on 17/3/12.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "MineViewController.h"
#import "MineTableViewCell.h"
#import "MoreViewController.h"
#import "VideosListViewController.h"
#import "MyPartViewController.h"
#import "VerifyPartViewController.h"
#import "UserAccountViewController.h"
#import "UserBalanceModel.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "MainDetailViewController.h"
#import "SettingViewController.h"

#import "InviteCodeViewController.h"

#import "WechatLoginViewController.h"
#import "ZLPhoto.h"

#define kCellName @"MineTableViewCell"

@interface MineViewController ()<UITableViewDelegate,UITableViewDataSource,ZLPhotoPickerViewControllerDelegate>
{
    
}
@property (nonatomic,strong) NSArray *nameArray;
@property (nonatomic,strong) NSArray *imageArray;
@property (nonatomic,strong) IBeaconModel *iBeaconModel;
@property (nonatomic,strong) UserBalanceModel *balanceModel;
@property (nonatomic , strong) NSMutableArray *assets;
@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navBarTitle:@"我"];
    [self firstStept];
    _labelMobile.text = kMobile;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    [self loadIBeaconData];
    [self loadBalanceData];
}

- (void)firstStept{
    _nameArray = @[@"邀请码",@"配音视频列表",@"设置"];
    _imageArray = @[@"authorization",@"video",@"management"];
    _tableView.frame = CGRectMake(_tableView.orginX, _tableView.orginY, _tableView.sizeWidth, _nameArray.count *50 + 60);
    [_tableView reloadData];
}

#pragma mark- 数据下载

- (void)loadIBeaconData{
    [[AFClient shareInstance] getMineMainInfoByUserId:kUserId progressBlock:^(NSProgress *progress) {
        
    } success:^(id responseBody) {
        if ([responseBody[@"code"] integerValue] == 200) {
            _iBeaconModel = [[IBeaconModel alloc] init];
            [_iBeaconModel setValuesForKeysWithDictionary:responseBody[@"data"]];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)loadBalanceData{
    [[AFClient shareInstance] getMyMoneyByUserId:kUserId progressBlock:^(NSProgress *progress) {
        
    } success:^(id responseBody) {
        if ([responseBody[@"code"] integerValue] == 200) {
            _balanceModel = [[UserBalanceModel alloc] init];
            [_balanceModel setValuesForKeysWithDictionary:responseBody[@"data"]];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - 点击事件
//点击中心按钮
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
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"只有授权用户才可以使用哦" message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"知道啦" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}
//点击左边按钮
- (IBAction)leftButtonClick:(UIButton *)sender {
    self.tabBarController.selectedIndex = 0;
}

#pragma mark - tableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _nameArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellName];
    cell.labelName.text = _nameArray[indexPath.row];
    cell.imageViewHeader.image = [UIImage imageNamed:_imageArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *storyboard = kMainStroyboard;
//    if (indexPath.row == 0) {//我的设备
//        //如果model 中存在 ibeacon 信息,则直接进入更改ibeacon名称页面
//        if (_iBeaconModel.id) {
//            MyPartViewController *mypartVC = [storyboard instantiateViewControllerWithIdentifier:@"MyPartViewController"];
//            mypartVC.ibeaconModel = _iBeaconModel;
//            mypartVC.beaconId = _iBeaconModel.id;
//            [self.navigationController pushViewController:mypartVC animated:YES];
//        }else{
//            VerifyPartViewController *verifyPartVC = [storyboard instantiateViewControllerWithIdentifier:@"VerifyPartViewController"];
//            [self.navigationController pushViewController:verifyPartVC animated:YES];
//        }
//    }else
    if (indexPath.row == 0) {//邀请码
        InviteCodeViewController *inviteVC = [storyboard instantiateViewControllerWithIdentifier:@"InviteCodeViewController"];
        inviteVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:inviteVC animated:YES];
    }else if (indexPath.row == 1){//配音视频列表
//        kAlert(@"配音视频列表");
        VideosListViewController *videosVC = [storyboard instantiateViewControllerWithIdentifier:@"VideosListViewController"];
//        videosVC.dataArray = _dataArray;
        videosVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:videosVC animated:YES];
    }else if (indexPath.row == 2){
        //设置
        SettingViewController *settingVC = [storyboard instantiateViewControllerWithIdentifier:@"SettingViewController"];
        [self.navigationController pushViewController:settingVC animated:YES];
    }else if (indexPath.row == 4){//账户余额
        UserAccountViewController *userAccountVC = [storyboard instantiateViewControllerWithIdentifier:@"UserAccountViewController"];
        userAccountVC.moneyStr = _balanceModel.balance;
        userAccountVC.withDrowMoneyStr = _balanceModel.withdrawals_balance;
        [self.navigationController pushViewController:userAccountVC animated:YES];
    }
    else{
        kAlert(@"该功能正在开发中...");
    }
//    else if (indexPath.row == 4){//关于有点装
//        MoreViewController *moreVC = [storyboard instantiateViewControllerWithIdentifier:@"MoreViewController"];
//        moreVC.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:moreVC animated:YES];
//    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
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
