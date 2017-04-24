//
//  FindingViewController.m
//  Qian
//
//  Created by 周博 on 17/2/6.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "FindingViewController.h"
#import "FindingTableViewCell.h"
#import "MomentsViewController.h"

#define kCellName @"FindingTableViewCell"

@interface FindingViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    
}
@property (nonatomic,strong) NSArray *iconsArray;
@property (nonatomic,strong) NSArray *titlesArray;
@property (nonatomic,strong) UserInfoModel *userHeaderWork;
@end

@implementation FindingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navBarTitle:@"发现"];
    [self getANewPerson];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)newArraySetting{
    _iconsArray = @[@[@"ff_IconShowAlbum.png"],@[@"ff_IconQRCode.png",@"ff_IconShake.png"],@[@"ff_IconLocationService.png",@"ff_IconBottle.png"],@[@"shopping3.png",@"MoreGame.png"],@[@"xiaochengxu.png"]];
    _titlesArray = @[@[@"朋友圈"],@[@"扫一扫",@"摇一摇"],@[@"附近的人",@"漂流瓶"],@[@"购物",@"游戏"],@[@"小程序"]];
}

- (void)getANewPerson{
    NSMutableArray *array = [[FMDBHelper fmManger] selectDataByTableName:kOthreUserTable];
    if (array.count > 0) {
        _userHeaderWork = array[arc4random()%array.count];
    }
    [self newArraySetting];
}

#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _iconsArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0 || section == 4) {
        return 1;
    }else{
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FindingTableViewCell *cell = (FindingTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kCellName];    
    cell.imageViewHeader.image = [UIImage imageNamed:_iconsArray[indexPath.section][indexPath.row]];
    
    cell.labelName.text = _titlesArray[indexPath.section][indexPath.row];
    
    if (indexPath.section != 0) {
        cell.imageViewNews.hidden = YES;
        cell.imageViewRed.hidden = YES;
    }else{
        if (!_userHeaderWork) {
            cell.imageViewNews.hidden = YES;
            cell.imageViewRed.hidden = YES;
        }else{
//            cell.imageViewNews.image = [UIImage imageWithData:_userHeaderWork.headImage];
            cell.imageViewNews.image = [BGFunctionHelper getImageFromSandBoxByImagePath:_userHeaderWork.headImage];
        }
    }
    
    if (indexPath.section == 0 || indexPath.section == 4) {
        cell.imageViewDown1.hidden = YES;
    }else{
        if (indexPath.row == 1) {
            cell.imageViewTop.hidden = YES;
        }else{
            cell.imageViewDown0.hidden = YES;
        }
    }
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 15;
    }else{
        return 20;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MomentsViewController* vc = [[MomentsViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
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
