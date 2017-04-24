//
//  MeViewController.m
//  Qian
//
//  Created by 周博 on 17/2/6.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "MeViewController.h"
#import "FindingTableViewCell.h"
#import "UserInfoViewController.h"
#import "WolletViewController.h"
#import "BorderHelper.h"

#define kCellName @"FindingTableViewCell"

@interface MeViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    
}
@property (nonatomic,strong) NSArray *iconsArray;
@property (nonatomic,strong) NSArray *titlesArray;
@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navBarTitle:@"我"];
    [self newArraySetting];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    [self reSettingUI];
}

- (void)reSettingUI{

    [[FMDBHelper fmManger] getFMDBBySQLName:kCreatSQL];
    [[FMDBHelper fmManger] createTableByTableName:kOthreUserTable];
    UserInfoModel *model = [[UserInfoModel alloc] init];
    
    model = [[[FMDBHelper fmManger] selectDataByTableName:kOthreUserTable] firstObject];
//    _imageViewHeader.image = [UIImage imageWithData:model.headImage];
    _imageViewHeader.image = [BGFunctionHelper getImageFromSandBoxByImagePath:model.headImage];
    _imageViewHeader.layer.masksToBounds = YES;
    _imageViewHeader.layer.cornerRadius = 5;
    _imageViewHeader.layer.borderColor = [kd2d2d2 CGColor];
    _imageViewHeader.layer.borderWidth = 0.5f;
    _labelName.text = model.name;
    _labelWechatNum.text = [NSString stringWithFormat:@"微信号: %@",model.wechatNum];
    
    [BorderHelper setBorderWithColor:kColorFrom0x(0xd9d9d9) view:_myheadView];
}

- (void)newArraySetting{
//    _imageViewHeader.backgroundColor = kRandomColor;
    _iconsArray = @[@[@"Album Color.png",@"Saved Color.png",@"Wallet Color.png",@"kaquan.png"],@[@"Stickers Color.png"],@[@"Settings.png"]];
    _titlesArray = @[@[@"相册",@"收藏",@"钱包",@"卡包"],@[@"表情"],@[@"设置"]];
}

#pragma mark - 个人信息

- (IBAction)userInfoButtonClick:(UIButton *)sender {
    UIStoryboard *storyboard = kWechatStroyboard;
    UserInfoViewController *userInfo = [storyboard instantiateViewControllerWithIdentifier:@"UserInfoViewController"];
    userInfo.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:userInfo animated:YES];
}


#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 4;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FindingTableViewCell *cell = (FindingTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kCellName];
    
    cell.imageViewHeader.image = [UIImage imageNamed:_iconsArray[indexPath.section][indexPath.row]];
    
    cell.labelName.text = _titlesArray[indexPath.section][indexPath.row];
    
    cell.imageViewNews.hidden = YES;
    cell.imageViewRed.hidden = YES;
    
    if (indexPath.section > 0) {
        cell.imageViewDown1.hidden = YES;
    }
    if (indexPath.section == 0) {
        if (indexPath.row < 3) {
            cell.imageViewDown0.hidden = YES;
        }
        if (indexPath.row > 0) {
            cell.imageViewTop.hidden = YES;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 2) {
            UIStoryboard * storyboard = kWechatStroyboard;
            WolletViewController * wolletVC = [storyboard instantiateViewControllerWithIdentifier:@"WolletViewController"];
            [wolletVC navBarTitle:@"钱包"];
            [wolletVC wechatRightButtonClick:@"•••"];
            wolletVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:wolletVC animated:YES];
        }else{
            kAlert(@"正在开发中");
        }
    }else{
        kAlert(@"正在开发中");
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
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
