//
//  WechatPayViewController.m
//  Qian
//
//  Created by 周博 on 17/3/11.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "WechatPayViewController.h"
#import "WechatPayTableViewCell.h"
#import "WechatPayChangeViewController.h"
#import "BGItemsViewController.h"
#import "BorderHelper.h"

#define kCellName @"WechatPayTableViewCell"

@interface WechatPayViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    
}
@property (nonatomic,strong) UIButton *rightBTN;
@property (nonatomic,strong) NSMutableArray *dataArray;
@end

@implementation WechatPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navBarRButton];
//    [self tableViewSetting];
    [self deepViewSetting];
}

- (void)viewWillAppear:(BOOL)animated{
    [self tableViewSetting];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    BGNotiView *notiView = [[BGNotiView alloc] initWithFrame:CGRectMake(_tableView.center.x/2, 64 , 165, 50) contentText:@"点击添加更多条目" direction:up];
    [[BGNotiView defaultManager] showNotiViewByFrame:CGRectMake(kScreenSize.width/2 - 165/2, 0 , 165, 50) contentText:@"点击添加更多条目" direction:up inVC:self];
}

- (void)deepViewSetting{
    [BorderHelper setBorderWithColor:kd2d2d2 view:_keyboardView];
    [BorderHelper setBorderWithColor:kd2d2d2 view:_viewItem1];
    [BorderHelper setBorderWithColor:kd2d2d2 view:_viewItem2];
    [BorderHelper setBorderWithColor:kd2d2d2 view:_viewItem3];
}

- (void)tableViewSetting{
    [_tableView registerClass:[WechatPayTableViewCell class] forCellReuseIdentifier:kCellName];
    
    [[FMDBHelper fmManger] createWechatPayUserTable];

    _dataArray = [NSMutableArray array];
    _dataArray = [[FMDBHelper fmManger] selectWechatPayUserWhereValue1:nil value2:nil isNeed:NO];
    if (_dataArray.count == 0) {
        for (int i = 0; i < 5; i ++) {
            
            [[FMDBHelper fmManger] insertWechatPayUserByType:@"1" money:@"1000" startDate:[BGDateHelper getTimeStempByString:[BGDateHelper seeDay][5] havehh:YES] endDate:[BGDateHelper getTimeStempByString:[BGDateHelper seeDay][5] havehh:YES] remark:@" " reason:@" " userName:@"有点逗"];
        }
        _dataArray = [[FMDBHelper fmManger] selectWechatPayUserWhereValue1:nil value2:nil isNeed:NO];
    }
    
    [self.tableView reloadData];

}

- (void)clickNavTitle:(UIButton *)button{
    BGItemsViewController *bgItemsVC = [BGItemsViewController viewWithFrameBySuperView:self.navigationItem.titleView];
    BGItemsAction * action = [BGItemsAction actionWithTitle:@"添加条目" handler:^(BGItemsAction *action) {
        [[FMDBHelper fmManger] insertWechatPayUserByType:@"1" money:@"1000" startDate:[BGDateHelper getTimeStempByString:[BGDateHelper seeDay][5] havehh:YES] endDate:[BGDateHelper getTimeStempByString:[BGDateHelper seeDay][5] havehh:YES] remark:@" " reason:@" " userName:@"有点逗"];
        _dataArray  = [[FMDBHelper fmManger] selectWechatPayUserWhereValue1:nil value2:nil isNeed:NO];
        [self.tableView reloadData];
    }];
    [bgItemsVC addActions:action];
    [self presentViewController:bgItemsVC animated:YES completion:nil];
}

- (void)navBarRButton{
    _rightBTN = [UIButton buttonWithType:UIButtonTypeCustom];

    [_rightBTN setFrame:CGRectMake(0, 0, 20, 18)];
    [_rightBTN setImage:[UIImage imageNamed:@"ren(1)"] forState:UIControlStateNormal];
    
    [_rightBTN addTarget:self action:@selector(rightButtonOpen:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc] initWithCustomView:_rightBTN];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = 0;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, rightItem, nil];
    
}

#pragma mark - 点击事件
- (void)rightButtonOpen:(UIButton *)button{
    //点击添加一条数据,跳入到详情页面进行修改
//    
//    UIStoryboard *storyboard = kWechatStroyboard;
//    WechatPayChangeViewController *detailVC = [storyboard instantiateViewControllerWithIdentifier:@"WechatPayChangeViewController"];
//    [self.navigationController pushViewController:detailVC animated:YES];
//    
}

#pragma mark - tableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WechatPayModel *model = _dataArray[indexPath.row];
    WechatPayTableViewCell *cell = (WechatPayTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kCellName];
    if (!cell) {
        cell = [[WechatPayTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellName];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell showDataWithModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    WechatPayTableViewCell *cell = (WechatPayTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.row == _dataArray.count -1) {
        return [cell cellHeight] + 15;
    }
    return [cell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //拿到了点击对象的Id
    
    WechatPayModel *model = _dataArray[indexPath.row];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"操作选择" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *getAction = [UIAlertAction actionWithTitle:@"到账" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //到账
        //判断是否是零钱提现,否则隐藏
        
        [[FMDBHelper fmManger] insertWechatPayUserByType:@"2" money:model.money startDate:model.startDate endDate:model.endDate remark:model.remark reason:model.reason userName:model.userName];
        _dataArray  = [[FMDBHelper fmManger] selectWechatPayUserWhereValue1:nil value2:nil isNeed:NO];
        [self.tableView reloadData];
    }];
    
    UIAlertAction *editAction = [UIAlertAction actionWithTitle:@"编辑" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //编辑
        UIStoryboard *storyboard = kWechatStroyboard;
        WechatPayChangeViewController *detailVC = [storyboard instantiateViewControllerWithIdentifier:@"WechatPayChangeViewController"];
        detailVC.payId = model.Id;
        [self.navigationController pushViewController:detailVC animated:YES];
    }];
    
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        //删除
        
        [[FMDBHelper fmManger] deleteDataByTableName:kWechatPayTable TypeName:@"Id" TypeValue:model.Id];
        _dataArray = [[FMDBHelper fmManger] selectWechatPayUserWhereValue1:nil value2:nil isNeed:NO];
        [_tableView reloadData];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //取消
    }];
    
    if (model.type.integerValue == 1) {
        [alert addAction:getAction];
    }
    [alert addAction:editAction];
    [alert addAction:deleteAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    UIView *view = [[UIView alloc] init];
//    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
//    return view;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 15;
//}

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
